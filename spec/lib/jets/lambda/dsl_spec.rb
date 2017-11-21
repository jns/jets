require "spec_helper"

describe Jets::Lambda::Dsl do
  context "StoresController" do
    let(:controller) { StoresController.new({}, nil, "new") }

    it "tasks" do
      tasks = StoresController.all_tasks.keys
      expect(tasks).to eq [:index, :new, :show]

      index_task = StoresController.all_tasks[:index]
      expect(index_task).to be_a(Jets::Lambda::Task)
      expect(index_task.properties).to eq(
        dead_letter_config: "arn", timeout: 20, role: "myrole", memory_size: 1000
      )
    end

    it "timeout" do
      task = StoresController.all_tasks[:new]
      expect(task.properties).to eq(timeout: 35)
    end

    it "environment" do
      task = StoresController.all_tasks[:show]
      expect(task.properties[:environment]).to eq({
        variables: {
          key1: "value1",
          key2: "value2",
        }})
    end

    it "memory_size" do
      task = StoresController.all_tasks[:show]
      expect(task.properties[:memory_size]).to eq 1024
    end
  end

  context "Admin::StoresController" do
    let(:controller) { Admin::StoresController.new({}, nil, "new") }

    it "tasks should not include tasks from parent class" do
      tasks = Admin::StoresController.all_tasks.keys
      # pp tasks
      expect(tasks).to eq []
    end
  end
end
const { Task } = require("./tasks");

const resolvers = {
  Query: {
    tasks: async () => await Task.find(),
    task: async (_, { id }) => await Task.findById(id),
  },
  Mutation: {
    addTask: async (_, { title, description }) => {
      const task = new Task({ title, description, completed: false });
      return await task.save();
    },
    updateTask: async (_, { id, title, description, completed }) => {
      return await Task.findByIdAndUpdate(
        id,
        { title, description, completed },
        { new: true }
      );
    },
    deleteTask: async (_, { id }) => await Task.findByIdAndRemove(id),
  },
};

module.exports = resolvers;

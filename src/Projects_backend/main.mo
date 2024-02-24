import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";

actor {
  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };
  // The type of a Project identifier.
  public type ProjectId = Nat32;
  // The type of a Project.
    public type Project = {
    name : Text;
    tasks : List.List<Text>;
  };

  /**
   * Application State
   */

  // The next available Project identifier.
  private stable var next : ProjectId = 1;

  // The Project data store.
  private stable var Projects : Trie.Trie<ProjectId, Project> = Trie.empty();

  /**
   * High-Level API
   */

  // Create a Project.
  public func create(Project : Project) : async ProjectId {
    let ProjectId = next;
    next += 1;
    Projects := Trie.replace(
      Projects,
      key(ProjectId),
      Nat32.equal,
      ?Project,
    ).0;
    return ProjectId;
  };

  // Read a Project.
  public query func read(ProjectId : ProjectId) : async ?Project {
    let result = Trie.find(Projects, key(ProjectId), Nat32.equal);
    return result;
  };

  // Update a Project.
  public func update(ProjectId : ProjectId, Project : Project) : async Bool {
    let result = Trie.find(Projects, key(ProjectId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      Projects := Trie.replace(
        Projects,
        key(ProjectId),
        Nat32.equal,
        ?Project,
      ).0;
    };
    return exists;
  };

  // Delete a Project.
  public func delete(ProjectId : ProjectId) : async Bool {
    let result = Trie.find(Projects, key(ProjectId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      Projects := Trie.replace(
        Projects,
        key(ProjectId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  

  public query func readAll() : async Trie.Trie<ProjectId, Project> {
    return (Projects);
  };
  /**
   * Utilities
   */
  // Create a trie key from a Project identifier.
  private func key(x : ProjectId) : Trie.Key<ProjectId> {
    return { hash = x; key = x };
  };
};

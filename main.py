import configparser
from neo4j import GraphDatabase

class HelloWorldExample:

    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        self.driver.close()

    def print_greeting(self, message):
        with self.driver.session() as session:
            greeting = session.write_transaction(self._create_and_return_greeting, message)
            print(greeting)

    @staticmethod
    def _create_and_return_greeting(tx, message):
        result = tx.run("CREATE (a:Greeting) "
                        "SET a.message = $message "
                        "RETURN a.message + ', from node ' + id(a)", message=message)
        return result.single()[0]


if __name__ == "__main__":
    # ===== Configuration for Neo4j Database
    config = configparser.ConfigParser()
    config.read('neo4j.ini')
    uri = config['NEO4J']['uri']
    user = config['NEO4J']['user']
    password = config['NEO4J']['password']

    greeter = HelloWorldExample(uri, user, password)  # HelloWorldExample(url, user, password)
    greeter.print_greeting("hello, world")
    greeter.close()

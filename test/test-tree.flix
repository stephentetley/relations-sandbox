
namespace TestTree {

    use FlixSandbox.RoseTree;
    use FlixSandbox.RoseTree.{Node};

    use RelLib/Tree.Level3;
    use RelLib/Tree.Level3.{RootOf3, Level1Of3, Level2Of3, Level3Of3};


    @test
    def testAll(): Int32 & Impure = 
        Console.printLine("Running...");
        test01();
        FlixSandbox/RoseTree.map(ToString.toString, t1()) |> FlixSandbox/RoseTree.drawTree |> println;
        [("A", "B1", "X"), ("A", "B2", "Y")] |> RelLib/Tree.printAsTree3;
        [("Top", "B1", "X", 100), ("Top", "B1", "Y", 101)] |> RelLib/Tree.printAsTree4;
        [("Top", "B1", "X", 100, "hello"), ("Top", "B1", "Y", 101, "world")] |> RelLib/Tree.printAsTree5;
        0


    pub def t1(): RoseTree[Level3[String, Char, Int32]] = 
        Node(RootOf3, Node(Level1Of3("hello"), Node(Level2Of3('X'), Node(Level3Of3(1), Nil) :: Nil) :: Nil) ::Nil)


    rel Organization(set: String, pump: String)
    rel Pump(name: String, pumpType: String)

    rel PumpSet(name: String, set: String)
    rel PumpId(name: String, ident: String)

    def test01(): Unit & Impure = 
        query rules() select (x1, x2) from Organization(x1, x2)
            |> RelLib/Tree.printAsTree2


    def rules(): #{Organization, Pump, PumpSet, PumpId |r} =  #{

        Organization(set, pumpId) :- 
            Pump(name, _) ,
            PumpSet(name, set),
            PumpId(name, pumpId).

        Pump("Booster Set 1 Pump-1", "Centrifugal Pump").
        Pump("Booster Set 1 Pump-2", "Centrifugal Pump").
        Pump("Backflush Pump", "Centrifugal Pump").
        Pump("Final Effluent Pump-1", "Submersible Pump").
        Pump("Final Effluent Pump-2", "Submersible Pump").
        Pump("Booster Set 2 Pump-1", "Centrifugal Pump").
        Pump("Booster Set 2 Pump-2", "Centrifugal Pump").

        PumpSet("Booster Set 1 Pump-1", "Booster Set 1").
        PumpSet("Booster Set 1 Pump-2", "Booster Set 1").
        PumpSet("Backflush Pump", "Backflush").
        PumpSet("Final Effluent Pump-1", "Final Effluent").
        PumpSet("Final Effluent Pump-2", "Final Effluent").
        PumpSet("Booster Set 2 Pump-1", "Booster Set 2").
        PumpSet("Booster Set 2 Pump-2", "Booster Set 2").

        PumpId("Booster Set 1 Pump-1", "Pump-1").
        PumpId("Booster Set 1 Pump-2", "Pump-2").
        PumpId("Backflush Pump", "Backflush Pump").
        PumpId("Final Effluent Pump-1", "Pump-1").
        PumpId("Final Effluent Pump-2", "Pump-2").
        PumpId("Booster Set 2 Pump-1", "Pump-1").
        PumpId("Booster Set 2 Pump-2", "Pump-2").

    }

}

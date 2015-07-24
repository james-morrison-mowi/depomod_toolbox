classdef CollectionTest < matlab.unittest.TestCase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Workfile:   RunCollectionTest.m  $
% $Revision:   1.2  $
% $Author:   ted.schlicke  $
% $Date:   May 28 2014 13:03:46  $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % These tests test the AutoDepomod.Project project
    %
    
    properties
        Project;
        Collection;
        Path;
    end
    
    methods(TestMethodSetup)
        function setup(testCase)

            testDir = what('AutoDepomod\+Test');
            testCase.Path = [testDir.path,'\Fixtures\Gorsten'];
            testCase.Project = AutoDepomod.Project.create(testCase.Path);
        end
    end
    
    methods (Test)

        function testFullCollectionIni(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);
          
            verifyEqual(testCase, collection.project.name, 'Gorsten');
            verifyEqual(testCase, collection.type, []);
            verifyEqual(testCase, class(collection.list{1}), 'AutoDepomod.V1.Run.Benthic');
            verifyEqual(testCase, class(collection.list{3}), 'AutoDepomod.V1.Run.EmBZ');
            verifyEqual(testCase, class(collection.list{5}), 'AutoDepomod.V1.Run.TFBZ');
            verifyEqual(testCase, size(collection.list, 1), 6);
        end
        
        function testBenthicCollectionIni(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project, 'type', 'B');
          
            verifyEqual(testCase, collection.project.name, 'Gorsten');
            verifyEqual(testCase, collection.type, 'B');
            verifyEqual(testCase, class(collection.list{1}), 'AutoDepomod.V1.Run.Benthic');
            verifyEqual(testCase, size(collection.list, 1), 2);
        end
        
        function testEmBZCollectionIni(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project, 'type', 'E');
          
            verifyEqual(testCase, collection.project.name, 'Gorsten');
            verifyEqual(testCase, collection.type, 'E');
            verifyEqual(testCase, class(collection.list{1}), 'AutoDepomod.V1.Run.EmBZ');
            verifyEqual(testCase, size(collection.list, 1), 2);
        end
        
        function testTFBZCollectionIni(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project, 'type', 'T');
          
            verifyEqual(testCase, collection.project.name, 'Gorsten');
            verifyEqual(testCase, collection.type, 'T');
            verifyEqual(testCase, class(collection.list{1}), 'AutoDepomod.V1.Run.TFBZ');
            verifyEqual(testCase, size(collection.list, 1), 2);
        end
        
        function testCustomSizeMethod(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);
            verifyEqual(testCase, collection.size, 6);
        end
        
        function testGetByItem(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);
            benthicRun = collection.item(1);
            EmBZRun    = collection.item(3);
            
            verifyInstanceOf(testCase, benthicRun, 'AutoDepomod.V1.Run.Benthic');
            verifyEqual(testCase, benthicRun.runNumber, '1');
            
            verifyInstanceOf(testCase, EmBZRun, 'AutoDepomod.V1.Run.EmBZ');
            verifyEqual(testCase, EmBZRun.runNumber, '20');
        end
        
        function testInvalidGetByItem(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);

            verifyError(testCase, @() collection.item(10), 'MATLAB:badsubscript');
        end
        
        function testGetByNumberFullCollection(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);
            run = collection.number(1);
                      
            % if 2 runs in this general collection have run number of 1,
            % the first (usually benthic) is returned
            verifyInstanceOf(testCase, run, 'AutoDepomod.V1.Run.Benthic');
            verifyEqual(testCase, run.runNumber, '1');
        end
        
        function testGetByNumberBenthicOnly(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project, 'type', 'B');
            run = collection.number(1);

            
            verifyInstanceOf(testCase, run, 'AutoDepomod.V1.Run.Benthic');
            verifyEqual(testCase, run.runNumber, '1');
        end
        
        function testGetByNumberEmBZOnly(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project, 'type', 'E');
            run = collection.number(21);
                        
                        
            verifyInstanceOf(testCase, run, 'AutoDepomod.V1.Run.EmBZ');
            verifyEqual(testCase, run.runNumber, '21');
        end
        
        function testInvalidGetByNumber(testCase)
            collection = AutoDepomod.Run.Collection(testCase.Project);
            run = collection.number(5);
                        
            verifyInstanceOf(testCase, run, 'cell');
            verifyTrue(testCase, isempty(run));
        end
        
        
    end
    
    
end

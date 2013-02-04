@experimentsImport @import
Feature: Experiments background import
	In order to be able to automate experiments import
	As a MT developer
	I need to be able to copy experiment to given folder and create new experiment from it

	Scenario: Experiments watcher is watching given folder
		Given there is a folder where I can upload experiments
		When I start experiments watcher
		Then experiments watcher should watch that folder		

	Scenario: New experiment detection
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		And there is no experiment called "new-experiment"
		When I upload experiment called "new-experiment"
		Then experiments watcher should find it 

	Scenario: Imported experiments are not imported again
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		When there is already imported experiment called "old-experiment"
		Then experiments watcher should not find it

	Scenario: New experiment is imported only once
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		And there is no experiment called "new-experiment"
		When I upload experiment called "new-experiment"
		Then experiments watcher should find only once 

	Scenario: Watcher is using default paths without config
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		When I upload experiment called "new-experiment"
		And I forget to upload "config.neon" for "new-experiment"
		Then experiments watcher should use "source.txt" for "source sentences" in "new-experiment"
		Then experiments watcher should use "reference.txt" for "reference sentences" in "new-experiment"

	Scenario: Watcher is using paths provided config.neon
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		When I upload experiment called "new-experiment"
		And "new-experiment" has config:
		"""
		source: config-source.txt
		reference: config-reference.txt
		"""
		Then experiments watcher should use "config-source.txt" for "source sentences" in "new-experiment"
		Then experiments watcher should use "config-reference.txt" for "reference sentences" in "new-experiment"
	
	Scenario: Watcher is using default paths if path is missing in config.neon
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		When I upload experiment called "new-experiment"
		And "new-experiment" has config:
		"""
		"""
		Then experiments watcher should use "source.txt" for "source sentences" in "new-experiment"
		Then experiments watcher should use "reference.txt" for "reference sentences" in "new-experiment"

	Scenario Outline: Watcher is complaining about missing sources
		Given there is a folder where I can upload experiments
		And experiments watcher is running
		When I upload experiment called "new-experiment"
		And I forget to upload "<file>" for "new-experiment"
		Then experiments watcher should complain about missing "<source>" for "new-experiment"

		Examples:
			| file		| source		|
			| source.txt	| source sentences 	|
			| reference.txt	| reference sentences	|


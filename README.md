# Simplified Bayesian Network for Production Incident Analysis 

A probabilistic model to understand causes and risks of incidents in a microservices infrastructure   

As a DevOps/Platform Engineer apprentice in a SAAS company, I frequently observe teams rigging the fire alarm when production alerts trigger. Engineers from Juniors to Manager rush in a call all together to:   

- Understand the problem's nature, impact and scope
- Investigate root causes
     
This inspired me to explore how a Bayesian network could help highlighting probable causes and predict potential consequences  

This repository contains a **very simplified** POC implementation using ~10 key variables.   

# The Bayesian Network structure

the structure was made by myself.

![./bn.png](./bn.png)

For real case usage, please use a structure learning algorithm to find your bayesian network structure.

## Noisy OR

Because some variables have a lot of parent dependences, we sometime want to put Noisy OR to reduce the network complexity.

In our case, we will add a Noisy OR on both variables : 

- Slowdown
- Alert triggered
- High error rate

Standard CPT for Slowdown with 5 binary parents would be 2^5 = 32 parameters  
With a Noisy-OR it gets reduced to only 5 parameters 

# Define all the questions

Based on the number of nodes and the Noisy OR in the bayesian network aswell as the number of values , we need at least 

```4 + 6 + 8 + 4 + 5 + 3 + 2 + 2 + 4 = 38``` questions to ask to the experts in order to create all our probability distribution.


## Questions

### Charge des services :
1. Quelle est la probabilité qu'un fort trafic utilisateur entraîne une augmentation de la charge des services ?
2. Quelle est la probabilité qu'une panne de scaling entraîne une augmentation de la charge des services ?
3. Quelle est la probabilité qu'une panne de scaling et un fort trafic utilisateur entraînent une augmentation de la charge des services ?
4. Quelle est la probabilité qu'un trafic utilisateur normal sans panne de scaling entraîne une augmentation de la charge des services ?

### Queue dangereuse :
5. Quelle est la probabilité qu'une forte charge des services entraîne une dégradation significative de l'état d'une queue ?
6. Quelle est la probabilité d'observer une dégradation de l'état de la queue alors que la charge des services n'est pas forte ?

### BDD dangereuse :
7. Quelle est la probabilité qu'une forte charge des services entraîne une dégradation significative de l'état d'une base de données ?
8. Quelle est la probabilité d'observer une dégradation de l'état d'une base de données alors que la charge des services n'est pas forte ?

### Noisy OR Taux d'erreur :
9. Quelle est la probabilité qu'un récent déploiement entraîne une augmentation du taux d'erreur global de la plateforme ?
10. Quelle est la probabilité qu'une panne d'un service externe entraîne une augmentation du taux d'erreur global de la plateforme ?
11. Quelle est la probabilité qu'une base de données dans un état dangereux entraîne une augmentation du taux d'erreur global de la plateforme ?

### Noisy OR sur Ralentissement :
12. Quelle est la probabilité qu'une queue dans un état dangereux entraîne des ralentissements ?
13. Quelle est la probabilité qu'une base de données dans un état dangereux entraîne des ralentissements ?
14. Quelle est la probabilité qu'une panne de scaling entraîne des ralentissements ?
15. Quelle est la probabilité qu'un récent déploiement entraîne des ralentissements ?
16. Quelle est la probabilité qu'une panne d'un service externe entraîne des ralentissements ?

### Noisy OR sur Alerte :
17. Quelle est la probabilité qu'une queue dans un état dangereux entraîne une alerte ?
18. Quelle est la probabilité qu'une base de données dans un état dangereux entraîne une alerte ?
19. Quelle est la probabilité que des ralentissements entraînent une alerte ?
20. Quelle est la probabilité qu'une augmentation du taux d'erreur global de la plateforme entraîne une alerte ?

### Criticité :
21. Quelle est la probabilité d'avoir un incident P0 en cas de ralentissement ?
22. Quelle est la probabilité d'avoir un incident P1 en cas de ralentissement ?
23. Quelle est la probabilité d'avoir un incident P0 en cas d'augmentation du taux d'erreur global de la plateforme ?
24. Quelle est la probabilité d'avoir un incident P1 en cas d'augmentation du taux d'erreur global de la plateforme ?
25. Quelle est la probabilité d'avoir un incident P0 sans ralentissement ni augmentation du taux d'erreur global de la plateforme ?
26. Quelle est la probabilité d'avoir un incident P1 sans ralentissement ni augmentation du taux d'erreur global de la plateforme ?
27. Quelle est la probabilité d'avoir un incident P0 en cas de ralentissement et d'augmentation du taux d'erreur global de la plateforme ?
28. Quelle est la probabilité d'avoir un incident P1 en cas de ralentissement et d'augmentation du taux d'erreur global de la plateforme ?

### Message post-incident :
29. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'incident P0 sans alerte système ?
30. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'incident P1 sans alerte système ?
31. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'incident P2 sans alerte système ?
32. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'alerte et d'incident P0 ?
33. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'alerte et d'incident P1 ?
34. Quelle est la probabilité qu'un message post-incident soit écrit en cas d'alerte et d'incident P2 ?

### Root causes :
35. Quelle est la probabilité d'observer un fort trafic utilisateur ?
36. Quelle est la probabilité d'observer une panne de scaling infra ?
37. Quelle est la probabilité d'observer un nouveau déploiement ?
38. Quelle est la probabilité d'observer la panne d'un service externe ?

https://framaforms.org/interrogation-expert-platform-eng-pour-reseau-bayesien-1742933291?info=republished

## TODO :

- Find at least 10 variables for the bayesian network : DONE
- Create the network structure using personal knowledge : DONE
- Create and argument the addition of Noisy OR in the bayesian network : DONE
- Create the form to question my colleague for the CPTs of each variables connections in the network : DONE
- Ask my Platform and Infra co workers to fill the form
- Aggregate the final data into pyagrum
- Create the pyagrum implementation to test and show the quality of the model using multiple scenarios.


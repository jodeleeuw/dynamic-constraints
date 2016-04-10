require(plyr)
require(ggplot2)

#### load model run data and reduce to mean and se

load("data/output/PARSER-variations.Rdata")

sim_exp_reduced <- ddply(sim_exp, .(w, condition), function(s)with(s, c(m=mean(p),se=(sqrt(var(p)/length(p))))))

sim_exp_mod_reduced <- ddply(sim_exp_modified_model, .(w, c), function(s)with(s, c(m=mean(p),se=(sqrt(var(p)/length(p))))))

#### plot ####

ggplot(sim_exp_reduced, aes(x=w, y=m, ymin=m-se,ymax=m+se, colour=condition))+
  geom_line()+
  geom_pointrange(size=0.8)+
  labs(x="\nForgetting parameter value",y="Probability of a correct response\n", colour="Condition")+
  scale_colour_grey(start=0.2,end=0.6, labels=c("Four triples","One triple"))+
  theme_bw(base_size=16,base_family="Helvetica")+
  theme(panel.grid.major.x=element_blank(), panel.grid.minor.x=element_blank(),
        panel.grid.minor.y=element_blank(), panel.grid.major.y=element_line(colour=rgb(0.8,0.8,0.8)),
        legend.position=c(0.75,0.75))

ggplot(sim_exp_mod_reduced, aes(x=w, y=m, ymin=m-se,ymax=m+se, colour=c))+
  geom_line()+
  geom_pointrange(size=0.8)+
  labs(x="\nForgetting parameter value",y="Probability of a correct response\n", colour="Condition")+
  scale_colour_grey(start=0.2,end=0.6, labels=c("Four triples","One triple"))+
  theme_bw(base_size=16,base_family="Helvetica")+
  theme(panel.grid.major.x=element_blank(), panel.grid.minor.x=element_blank(),
        panel.grid.minor.y=element_blank(), panel.grid.major.y=element_line(colour=rgb(0.8,0.8,0.8)),
        legend.position=c(0.75,0.75))
#!/usr/bin/env python
# coding: utf-8

# In[8]:


import networkx as nx
# get_ipython().run_line_magic('matplotlib', 'inline')

import matplotlib.pyplot as plt


# In[9]:


G = nx.Graph()


# In[13]:


G.add_node(1)


# In[11]:


G.add_nodes_from([2,3])


# In[16]:


nx.draw_networkx(G,node_color='green', node_size=300)
plt.show()

# In[15]:


G.add_edge(1,2)


# In[17]:


nx.draw_networkx(G)


# In[18]:


e = (2,3)
G.add_edge(*e)


# In[19]:


G.add_edges_from([(1,2),(1,3)])


# In[20]:


nx.draw_networkx(G)


# In[23]:


print(G.number_of_nodes())


# In[25]:


print(G.edges())


# In[35]:


list(G.neighbors(1))


# In[36]:


list(G.neighbors(1))


# In[38]:


print(G.degree())


# In[39]:


print(G.has_edge(1,2))


# In[44]:


print(G.has_node(2))


# In[45]:


H = nx.Graph()
edgelist = [(0,1),(0,2),(1,2),(0,3)]


# In[46]:


H.add_edges_from(edgelist)


# In[47]:


nx.draw_networkx(H)


# In[50]:


H.remove_node(2)


# In[49]:





# In[51]:


nx.draw_networkx(H)


# In[52]:


B = nx.Graph(weekday='Friday',year=2015,month='December',day=12)


# In[53]:


B.graph['day'] = 21


# In[56]:


nx.draw(B)


# In[55]:


B.add_node('Spam')


# In[60]:


print(nx.info(B))


# In[71]:


B.add_edges_from([(1,2,{'color':'blue'}),(2,3,{'weight':4.7}),(2,4,{'weight':4.7})])


# In[72]:


B[2][3]['weight'] = 5


# In[73]:


B.edges(data=True)


# In[75]:


list(B.neighbors(2))


# In[ ]:

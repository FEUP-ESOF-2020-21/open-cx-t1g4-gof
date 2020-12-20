import discord
from discord.ext import commands

from models.question import Question
from models.talk import Talk

from datetime import datetime

from cogs.utils.db_interactor import DbInteractor as DB

from firebase_controller import FirebaseController as FB

class Participants(commands.Cog, name="Participants"):
    def __init__(self, bot):
        self.bot = bot

    @commands.command(name="question", aliases=["q"])
    @commands.guild_only()
    async def addMessage(self, ctx, *args):

        """Submit a new question"""

        talk_id = DB.get_channel_talk(ctx.message.guild.id, ctx.message.channel.id)

        if (talk_id == None):
            await ctx.send('This channel is not bound to a conference')
            return
        
        talk_id = talk_id[0]

        question = Question(" ".join(args), ctx.message.author.display_name, ctx.message.author.id, datetime.now())

        FB.addQuestion(talk_id, question)

# The setup function below is neccesarry. Remember we give bot.add_cog() the name of the class in this case MembersCog.
# When we load the cog, we use the name of the file.
def setup(bot):
    bot.add_cog(Participants(bot))

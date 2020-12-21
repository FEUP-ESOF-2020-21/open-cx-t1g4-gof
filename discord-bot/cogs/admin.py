import discord
from discord.ext import commands

from cogs.utils.db_interactor import DbInteractor as DB
from firebase_controller import FirebaseController as FB

class AdminCog(commands.Cog, name="Admin"):
    def __init__(self, bot):
        self.bot = bot

    @commands.command(name="$setTalk")
    @commands.guild_only()
    async def setTalk(self, ctx, talk_id):

        """Sets the current channel to upload questions to the given talk"""

        if (not ctx.author.guild_permissions.administrator):
            await ctx.send("🚫 Only admins can use this command!")
            return

        t = FB.getTalk(talk_id)
        if (t == None):
            await ctx.send("Talk does not exist")
            return
        
        DB.set_channel_talk(ctx.message.guild.id, ctx.message.channel.id, talk_id)
        
        await ctx.send(f"Set to track talk '{t.title}' by {t.speaker}")


    @commands.command(name="$unsetTalk")
    @commands.guild_only()
    async def unsetTalk(self, ctx):

        """Unsets the current channel from a talk"""

        if (not ctx.author.guild_permissions.administrator):
            await ctx.send("🚫 Only admins can use this command!")
            return

        DB.unset_channel_talk(ctx.message.guild.id, ctx.message.channel.id)
        
        await ctx.send(f"Channel is no longer tracking a talk")

# The setup function below is neccesarry. Remember we give bot.add_cog() the name of the class in this case MembersCog.
# When we load the cog, we use the name of the file.
def setup(bot):
    bot.add_cog(AdminCog(bot))

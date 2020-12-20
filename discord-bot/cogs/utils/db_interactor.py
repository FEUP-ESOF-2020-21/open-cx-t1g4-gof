import sqlite3

import discord
from discord.ext import commands

from contextlib import closing

_connection = sqlite3.connect("database.db")

class DbInteractor():

    @staticmethod
    def get_channel_talk(id_guild, id_channel):
        with closing(_connection.cursor()) as cursor:
            cursor = _connection.cursor()
            return cursor.execute("SELECT id_talk FROM Talks WHERE id_guild=? AND id_channel=? LIMIT 1", (id_guild, id_channel)).fetchone()

    @staticmethod
    def set_channel_talk(id_guild, id_channel, id_talk):
        with closing(_connection.cursor()) as cursor:
            cursor = _connection.cursor()
            cursor.execute("UPDATE Talks SET id_talk=? WHERE id_guild=? AND id_channel=?", (id_talk, id_guild, id_channel))
            cursor.execute("INSERT OR IGNORE INTO Talks (id_talk, id_guild, id_channel) VALUES (?, ?, ?)", (id_talk, id_guild, id_channel))
            _connection.commit()
    
    @staticmethod
    def unset_channel_talk(id_guild, id_channel):
        with closing(_connection.cursor()) as cursor:
            cursor = _connection.cursor()
            cursor.execute("DELETE FROM Talks WHERE id_guild=? AND id_channel=?", (id_guild, id_channel))
            _connection.commit()

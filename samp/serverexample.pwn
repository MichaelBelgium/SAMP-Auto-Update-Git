#include <a_samp>
#include <core>
#include <float>
#include <MV_AutoDeploy>

#define SQL_PASSWORD    ""
#define SQL_USER        ""
#define SQL_DB          ""
#define SQL_SERVER      "127.0.0.1"

#define SERVER_NAME 	"My server"

new MySQL:gCon;

main()
{
	print("\n----------------------------------");
	print("  Test Script\n");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	gCon = mysql_connect(SQL_SERVER, SQL_USER, SQL_DB, SQL_PASSWORD);
	if(mysql_errno(gCon) != 0)
		printf("Could not connect to database %s!", SQL_DB);
	else
		MV_AutoDeployInit(gCon);

	printf("Server loaded, running version %s", MV_GetServerVersion());

	SetGameModeText(GetCurrentServerVersion());
	return 1;
}

public OnGameModeExit()
{
	MV_AutoDeployExit();
	return 1;
}

public OnServerUpdateDetected(updateid, hash[], shorthash[], message[])
{
	new string[128];
	format(string, sizeof(string),"New update available: %s (%s - %i)", message, shorthash, updateid);
	SendClientMessageToAll(-1, string);
	print(string);
	return 1;
}

public OnUpcomingUpdateDetected(updateid, hash[], shorthash[], message[])
{
	new string[128];
	format(string, sizeof(string),"New upcoming feature: %s (%s - %i)", message, shorthash, updateid);
	SendClientMessageToAll(-1, string);
	print(string);
	return 1;
}

public OnServerIssueCreated(issueid, title[], priority[], kind[])
{
	new string[256];
	format(string, sizeof(string), "New issue detected: %s ( http://bitbucket.org/MichaelBelgium/foobar/issues/%i ) - Kind: %s - Priority: %s", title, issueid, kind, priority);
	SendClientMessageToAll(-1, string);
	print(string);
	return 1;
}

public OnServerIssueStatusChange(issueid, title[], oldstatus[], newstatus[])
{
	new string[256];
	format(string, sizeof(string), "Issue updated: %s (http://bitbucket.org/MichaelBelgium/foobar/issues/%i) - Status changed from '%s' to '%s'", title, issueid, oldstatus, newstatus);
	SendClientMessageToAll(-1, string);
	print(string);
	return 1;
}

public OnServerTagCreated(updateid, linkedtohash[], tagname[])
{
	SetGameModeText(GetCurrentServerVersion());
	return 1;
}

GetCurrentServerVersion()
{
	new version[128];
	format(version, sizeof(version), "%s %s", SERVER_NAME, MV_GetServerVersion());

	return version;
}

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Populate UUID Data Queue')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MG001801 - Midas MG Populate UUID Data Queue                 *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CSW218  *CREATE    Date 19Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D SValK1          C                   CONST('SWIFTUUIDIPAddress')
     D SValK2          C                   CONST('SWIFTUUIDLogInUser')
     D SValK3          C                   CONST('GlobalSystemPrefix')
     D ValidList       C                   CONST('GPLDAPVL')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PNumofMsg       S             10I 0
     D PDtaqPath       S             50A
     D WUserID         S             50A
     D WIPAddress      S             50A
     D WPAssword       S             50A

      ** Parameter Variables to call 'AOSVALR0'

     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A

      ** Validation List Parameter

     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PUserName       S            100A
     D PPassword1      S            600A
     D PPassword2      S            600A
     D PDescrptn       S           1000A

     D SysPrefix       S              2A

     D WFirst          S              1A
     D WRun            S              1A
     D PRtcd           S              7A
     D Idx             S              2  0

      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+

      ** Prototype for a Java String object

     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                       50A   CONST VARYING

      ** Prototype for Java String's getBytes method

     D cvtToBytes      PR          9999A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING

      ** Create GenerateUUID object

     D uUIDClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID')

      ** Prototype for GenerateUUID object creation (instantiation)

     D crtUUIDClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID':
     D                                     *CONSTRUCTOR)

      ** Prototype for Generate UUID class 'populateUUID' method

     D populateUUID    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID':
     D                                     'populateUUID')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   hostName                      O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   userName                      O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   password                      O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   queuePath                     O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   numOfMsgs                   10I 0 VALUE


      ** Create string objects

     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm5           S             10I 0
     D status          S               O   CLASS(*JAVA:'java.lang.String')
     D WRcvStr         S            500A   VARYING

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Create/Instantiate 'GenerateUUID' java object (one time only)
      ** so as to access its 'populateUUID' method later

     C                   IF        WFirst = 'Y'
     C                   EVAL      uUIDClassObj = crtUUIDClass()
     C                   EVAL      WFirst = 'N'
     C                   ENDIF

      ** Create java string/integer objects for all parameters to be passed to
      ** populateUUID method

     C                   EVAL      Parm1 = crtString(WIPAddress)
     C                   EVAL      Parm2 = crtString(WUserID)
     C                   EVAL      Parm3 = crtString(WPassword)
     C                   EVAL      Parm4 = crtString(PDtaqPath)
     C                   EVAL      Parm5 = PNumofMsg

      ** Invoke the populateUUIDDataQueue method of the UUIDClass object

     C                   EVAL      status = populateUUID(UUIDClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3:
     C                                                  Parm4:
     C                                                  Parm5)

      ** Convert the received java string to RPG bytes (Varying alpha field)

     C                   EVAL      WRcvStr = *BLANKS
     C                   EVAL      WRcvStr = cvtToBytes(status)

      ** Retrieve field stat from received string via substring function

     C                   IF        %SUBST(WRcvStr:1:9) <> 'COMPLETED'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PNumofMsg
     C                   PARM                    PDtaqPath

     C                   EVAL      DBPGM = 'MG001801'
     C                   EVAL      WFirst = 'Y'

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SValK1        PSValK1
     C                   PARM                    PSVal1
     C                   PARM      SValK2        PSValK2
     C                   PARM                    PSVal2
     C                   PARM      SValK3        PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10

     C                   IF        PRtcd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'

     C                   IF        PSVal1 = '*NRF  '
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(SValK1)
     C                   ENDIF

     C                   IF        PSVal2 = '*NRF  '
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = %TRIM(SValK2)
     C                   ENDIF

     C                   IF        PSVal3 = '*NRF  '
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = %TRIM(SValK3)
     C                   ENDIF
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      WIPAddress = PSVal1
     C                   EVAL      WUserID = PSVal2
     C                   EVAL      SysPrefix = PSVal3
     C                   ENDIF

     C                   EVAL      PValidList = ValidList
     C                   EVAL      PLibrary = SysPrefix + 'GMLIB'
     C                   EXSR      GetPassWord

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetPassWord - Get password in Validation List                     *
      *                                                                   *
      *********************************************************************
     C     GetPassWord   BEGSR

     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PRtnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      WUserID       PUserName
     C                   PARM      *BLANKS       PPassword1
     C                   PARM      *BLANKS       PPassword2
     C                   PARM      *BLANKS       PDescrptn
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      DBKEY  = WUserID
     C                   EVAL      DBFILE = 'GPLDAPVL'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WPassword =  PPassword1
     C                   ENDIF
     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************

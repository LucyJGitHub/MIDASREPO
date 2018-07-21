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
      *  Last Amend No. MD051100           Date 30May18               *
      *  Prev Amend No. CSW218  *CREATE    Date 19Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051100 - System generated Dump after executing MGC001801   *
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
 
     D*SValK1***       C                   CONST('SWIFTUUIDIPAddress')                      MD051100
     D*SValK2***       C                   CONST('SWIFTUUIDLogInUser')                      MD051100
     D*SValK3***       C                   CONST('GlobalSystemPrefix')                      MD051100
     D*ValidList       C                   CONST('GPLDAPVL')                                MD051100
 
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
     D PZonePrfx       S              2A                                                    MD051100
     D*WUserID**       S             50A                                                    MD051100
     D*WIPAddress      S             50A                                                    MD051100
     D*WPAssword       S             50A                                                    MD051100
 
      ***Parameter*Variables*to*call*'AOSVALR0'****************************                 MD051100
 
     D*PSValK1**       S             20A                                                    MD051100
     D*PSValK2**       S             20A                                                    MD051100
     D*PSValK3**       S             20A                                                    MD051100
     D*PSValK4**       S             20A                                                    MD051100
     D*PSValK5**       S             20A                                                    MD051100
     D*PSValK6**       S             20A                                                    MD051100
     D*PSValK7**       S             20A                                                    MD051100
     D*PSValK8**       S             20A                                                    MD051100
     D*PSValK9**       S             20A                                                    MD051100
     D*PSValK10*       S             20A                                                    MD051100
     D*PSVal1***       S            200A                                                    MD051100
     D*PSVal2***       S            200A                                                    MD051100
     D*PSVal3***       S            200A                                                    MD051100
     D*PSVal4***       S            200A                                                    MD051100
     D*PSVal5***       S            200A                                                    MD051100
     D*PSVal6***       S            200A                                                    MD051100
     D*PSVal7***       S            200A                                                    MD051100
     D*PSVal8***       S            200A                                                    MD051100
     D*PSVal9***       S            200A                                                    MD051100
     D*PSVal10**       S            200A                                                    MD051100
 
      ***Validation*List*Parameter*****************************************                 MD051100
 
     D*PRtnCode*       S              7A                                                    MD051100
     D*PActione*       S              1A                                                    MD051100
     D*PValidList      S             10A                                                    MD051100
     D*PLibraryst      S             10A                                                    MD051100
     D*PUserNamet      S            100A                                                    MD051100
     D*PPassword1      S            600A                                                    MD051100
     D*PPassword2      S            600A                                                    MD051100
     D*PDescrptn2      S           1000A                                                    MD051100
 
     D*SysPrefix       S              2A                                                    MD051100
 
     D WFirst          S              1A
     D WRun            S              1A
     D*PRtcd****       S              7A                                                    MD051100
     D*Idx******       S              2  0                                                  MD051100
 
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
     D                                     'com.misys.midas.bankfusion.+                    MD051100
     D                                     swift.SwiftUUID')                                MD051100
     D**********                           'com.misys.midas.bankfusion.+                    MD051100
     D**********                           util.GenerateUUID')                              MD051100
 
      ** Prototype for GenerateUUID object creation (instantiation)
 
     D crtUUIDClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+                    MD051100
     D                                     swift.SwiftUUID':                                MD051100
     D                                     *CONSTRUCTOR)                                    MD051100
     D**********                           'com.misys.midas.bankfusion.+                    MD051100
     D**********                           util.GenerateUUID':                              MD051100
     D**********                           *CONSTRUCTOR)                                    MD051100
 
      ** Prototype for Generate UUID class 'populateUUID' method
 
     D populateUUID    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+                    MD051100
     D                                     swift.SwiftUUID':                                MD051100
     D                                     'populateUUID')                                  MD051100
     D**********                           'com.misys.midas.bankfusion.+                    MD051100
     D**********                           util.GenerateUUID':                              MD051100
     D**********                           'populateUUID')                                  MD051100
     D                                     CLASS(*JAVA:'java.lang.String')
     D***hostName                      O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D**********                           CONST                                            MD051100
     D***userName                      O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D**********                           CONST                                            MD051100
     D***password                      O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D**********                           CONST                                            MD051100
     D   zonePrefx                     O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D                                     CONST                                            MD051100
     D   queuePath                     O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   numOfMsgs                   10I 0 VALUE
 
 
      ** Create string objects
 
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S             10I 0                                                  MD051100
     D*Parm3****       S               O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D*Parm4****       S               O   CLASS(*JAVA:'java.lang.String')                  MD051100
     D*Parm5****       S             10I 0                                                  MD051100
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
 
     C**********         EVAL      Parm1 = crtString(WIPAddress)                            MD051100
     C**********         EVAL      Parm2 = crtString(WUserID)                               MD051100
     C**********         EVAL      Parm3 = crtString(WPassword)                             MD051100
     C**********         EVAL      Parm4 = crtString(PDtaqPath)                             MD051100
     C**********         EVAL      Parm5 = PNumofMsg                                        MD051100
     C                   EVAL      Parm1 = crtString(PZonePrfx)                             MD051100
     C                   EVAL      Parm2 = crtString(PDtaqPath)                             MD051100
     C                   EVAL      Parm3 = PNumofMsg                                        MD051100
 
      ** Invoke the populateUUIDDataQueue method of the UUIDClass object
 
     C                   EVAL      status = populateUUID(UUIDClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3)                              MD051100
     C**********                                        Parm3:                              MD051100
     C**********                                        Parm4:                              MD051100
     C**********                                        Parm5)                              MD051100
 
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
     C                   PARM                    PZonePrfx                                  MD051100
     C                   PARM                    PNumofMsg
     C                   PARM                    PDtaqPath
 
     C                   EVAL      DBPGM = 'MG001801'
     C                   EVAL      WFirst = 'Y'
 
     C**********         CALL      'AOSVALR0'                                               MD051100
     C**********         PARM      *BLANKS       PRtcd                                      MD051100
     C**********         PARM      SValK1        PSValK1                                    MD051100
     C**********         PARM                    PSVal1                                     MD051100
     C**********         PARM      SValK2        PSValK2                                    MD051100
     C**********         PARM                    PSVal2                                     MD051100
     C**********         PARM      SValK3        PSValK3                                    MD051100
     C**********         PARM                    PSVal3                                     MD051100
     C**********         PARM      *BLANKS       PSValK4                                    MD051100
     C**********         PARM                    PSVal4                                     MD051100
     C**********         PARM      *BLANKS       PSValK5                                    MD051100
     C**********         PARM                    PSVal5                                     MD051100
     C**********         PARM      *BLANKS       PSValK6                                    MD051100
     C**********         PARM                    PSVal6                                     MD051100
     C**********         PARM      *BLANKS       PSValK7                                    MD051100
     C**********         PARM                    PSVal7                                     MD051100
     C**********         PARM      *BLANKS       PSValK8                                    MD051100
     C**********         PARM                    PSVal8                                     MD051100
     C**********         PARM      *BLANKS       PSValK9                                    MD051100
     C**********         PARM                    PSVal9                                     MD051100
     C**********         PARM      *BLANKS       PSValK10                                   MD051100
     C**********         PARM                    PSVal10                                    MD051100
 
     C**********         IF        PRtcd <> *BLANKS                                         MD051100
 
     C******LOCK         IN        LDA                                                      MD051100
     C**********         EVAL      DBFILE = 'SDSVALPD'                                      MD051100
 
     C**********         IF        PSVal1 = '*NRF  '                                        MD051100
     C**********         EVAL      DBASE = 001                                              MD051100
     C**********         EVAL      DBKEY = %TRIM(SValK1)                                    MD051100
     C**********         ENDIF                                                              MD051100
 
     C**********         IF        PSVal2 = '*NRF  '                                        MD051100
     C**********         EVAL      DBASE = 002                                              MD051100
     C**********         EVAL      DBKEY = %TRIM(SValK2)                                    MD051100
     C**********         ENDIF                                                              MD051100
 
     C**********         IF        PSVal3 = '*NRF  '                                        MD051100
     C**********         EVAL      DBASE = 003                                              MD051100
     C**********         EVAL      DBKEY = %TRIM(SValK3)                                    MD051100
     C**********         ENDIF                                                              MD051100
     C**********         OUT       LDA                                                      MD051100
     C**********         EXSR      *PSSR                                                    MD051100
 
     C**********         ELSE                                                               MD051100
     C**********         EVAL      WIPAddress = PSVal1                                      MD051100
     C**********         EVAL      WUserID = PSVal2                                         MD051100
     C**********         EVAL      SysPrefix = PSVal3                                       MD051100
     C**********         ENDIF                                                              MD051100
 
     C**********         EVAL      PValidList = ValidList                                   MD051100
     C**********         EVAL      PLibrary = SysPrefix + 'GMLIB'                           MD051100
     C**********         EXSR      GetPassWord                                              MD051100
 
     C                   ENDSR
      *********************************************************************
      ***/EJECT************************************************************                 MD051100
      *********************************************************************
      *********************************************************************                 MD051100
      **GetPassWord*-*Get*password*in*Validation*List**********************                 MD051100
      *********************************************************************                 MD051100
      *********************************************************************
     C*****GetPassWord   BEGSR                                                              MD051100
 
     C**********         CALL      'UT000033'                                               MD051100
     C**********         PARM      '*BLANKS'     PRtnCode                                   MD051100
     C**********         PARM      'F'           PAction                                    MD051100
     C**********         PARM                    PValidList                                 MD051100
     C**********         PARM                    PLibrary                                   MD051100
     C**********         PARM      WUserID       PUserName                                  MD051100
     C**********         PARM      *BLANKS       PPassword1                                 MD051100
     C**********         PARM      *BLANKS       PPassword2                                 MD051100
     C**********         PARM      *BLANKS       PDescrptn                                  MD051100
      *
     C**********         IF        PRtnCode <> *BLANKS                                      MD051100
     C**********         EVAL      DBKEY  = WUserID                                         MD051100
     C**********         EVAL      DBFILE = 'GPLDAPVL'                                      MD051100
     C**********         EVAL      DBASE = 004                                              MD051100
     C**********         EXSR      *PSSR                                                    MD051100
     C**********         ELSE                                                               MD051100
     C**********         EVAL      WPassword =  PPassword1                                  MD051100
     C**********         ENDIF                                                              MD051100
     C**********         ENDSR                                                              MD051100
 
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

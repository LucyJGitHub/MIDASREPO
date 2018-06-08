     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Reteieve UUID Data Queue')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MG001802 - Midas MG Retrieve UUID Data Queue                 *
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


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PUUID           S             50A
     D WFirst          S              1A
     D WRun            S              1A
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

      ** Prototype for java string's getBytes method
     D cvtToBytes      PR          9999A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING

      ** Create UUIDClass object field
     D uUIDClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID')

      ** Prototype for GenerateUUID object creation (instantiation)
     D crtUUIDClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID':
     D                                     *CONSTRUCTOR)

      ** Prototype for Generate UUID class 'getUUID' method
     D getUUID         PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     util.GenerateUUID':
     D                                     'getUUID')
     D                                     CLASS(*JAVA:'java.lang.String')

      ** Create string objects
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D WRcvUUID        S               O   CLASS(*JAVA:'java.lang.String')

     D WCvUUID         S            999A   VARYING

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

      ** Create/Instantiate 'uUIDClass' java object (one time only)
      ** so as to access its 'getUUID' method later

     C                   IF        WFirst = 'Y'
     C                   EVAL      uUIDClassObj = crtUUIDClass()
     C                   EVAL      WFirst = 'N'
     C                   ENDIF

      ** Invoke the retrieveUUIDDataQueue method of the UUIDClass object

     C                   EVAL      WRcvUUID = getUUID(uUIDClassObj)

      ** Convert the received java string to RPG bytes (Varying alpha field)

     C                   EVAL      WCvUUID = *BLANKS
     C                   EVAL      WCvUUID = cvtToBytes(WRcvUUID)

      ** Retrieve field stat from received string via substring function

     C                   EVAL      PUUID = WCvUUID

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
     C                   PARM                    PUUID

     C                   EVAL      DBPGM = 'MG001802'
     C                   EVAL      WFirst = 'Y'

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

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************

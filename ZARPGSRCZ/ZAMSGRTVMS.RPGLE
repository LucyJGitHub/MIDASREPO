     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Retrieve message description')
      *****************************************************************
      *                                                               *
      *  Midas - Common routines                                      *
      *                                                               *
      *  ZAMSGRTVMS - Retrieve message description                    *
      *                                                               *
      *  Function:  This module retrieves the message descripion      *
      *             (first- and second-level text, and optional       *
      *             replacement values) of the received messageID.    *
      *                                                               *
      *  Component of: ZAMESSAGE - ZA messages service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003             Date 04Aug98               *
      *  Prev Amend No. CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion to APIs phase 2.  This module changed    *
      *           to return more detailed error information.          *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
 
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Data Structures and Arrays           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** The following data structure is used for the QMHRTVM system API.
      ** It was copied from the member QMHRTVM in QSYSINC/QRPGLESRC and
      ** modified to meet the present needs.
     D*****************************************************************
     D*Type Definition for the RTVM0100 format.
     D****                                                          ***
     D*****************************************************************
     DMsgInfo          DS
     D*                                             Qmh Rtvm RTVM0100
     D QMHBR01                 1      4B 0          INZ(0)
     D*                                             Bytes Return
     D QMHBAVL07               5      8B 0          INZ(0)
     D*                                             Bytes Available
     D QMHLMRTN02              9     12B 0          INZ(0)
     D*                                             Length Message Returned
     D QMHLMAVL02             13     16B 0          INZ(0)
     D*                                             Length Message Available
     D QMHLHRTN02             17     20B 0          INZ(0)
     D*                                             Length Help Returned
     D QMHLHAVL02             21     24B 0          INZ(0)
     D*                                             Length Help Available
 
      ** NOTE: the following two fields are not used as their texts would
      ** imply.  The 'First-level text' field actually gets the first-level
      ** plus some or all of the second-level, depending on their lengths.
      ** So the first-level field has been defined as long enough to take
      ** both parts of the message, and the length fields above used to
      ** split them up.
     D QMHSSAGE02             25   3176A
     D*                                             First-level message text
     D QMHMH02              3177   3177A
     D*                                             Second-level message text
     D*****************************************************************
 
      ** The following data structure is used for the QMHRTVM system API,
      ** to contain the error code structure.
      ** It was copied from the member QUSEC in QSYSINC/QRPGLESRC, and the
      ** variable-length field at the end of the structure set to 8 for the .
      ** amount of error data.  Note that the structure was copied in and
      ** amended, rather than being /COPYd principally so that the Bytes
      ** Provided field can be initialised with the INZ keyword.
     DQUSEC            DS
     D*                                             Qus EC
      ** The %LEN initialisation technique cannot be used at the time of
      ** development because it is not supported below V3R7M0; but it could
      ** and should be reintroduced at a later date.
     D*QUSBPRV****             1      4B 0          INZ(%LEN(QUSED01))
     D QUSBPRV                 1      4B 0          INZ(16)
     D*                                             Bytes Provided
     D QUSBAVL                 5      8B 0          INZ(0)
     D*                                             Bytes Available
     D QUSEI                   9     15
     D*                                             Exception Id
     D QUSERVED               16     16
     D*                                             Reserved
     D QUSED01                17     32
     D*                                      Exception data
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Complete message information
     D CompMsg         S           3000A
 
      ** Level of message to return (1,0S, from caller - 0 = both, 1 = first
      ** level only, 2 = second level only)
     D Level           S              1A
 
      ** Length of message information
      ** The %LEN initialisation technique cannot be used at the time of
      ** development because it is not supported below V3R7M0; but it could
      ** and should be reintroduced at a later date.
     D*LenMsgInf***    S              9B 0 INZ(%LEN(MsgInfo))
     D LenMsgInf       S              9B 0 INZ(3176)
 
      ** Name of returned format
     D FormatName      S              8A   INZ('RTVM0100')
 
      ** Qualified message file name
     D MsgFileLib      S             20A
 
      ** Length of replacement data
      ** The %LEN initialisation technique cannot be used at the time of
      ** development because it is not supported below V3R7M0; but it could
      ** and should be reintroduced at a later date.
     D*LenRepData***   S              9B 0 INZ(%LEN(#MsgData))
     D LenRepData      S              9B 0 INZ(45)
 
      ** Replace substitution values
     D RepSubVal       S             10A   INZ('*YES')
 
      ** Return format control characters
     D RtnFmtCtrl      S             10A   INZ('*NO')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      *****************************************************************
 
     C
      ** Start of Main processing
      ** ========================
 
      ** Clear the system API's returned fields to prevent data corruption
      ** on subsequent calls; similarly for the complete message field.
     C                   CLEAR                   QMHSSAGE02
     C                   CLEAR                   QMHMH02
     C***                CLEAR                   CompMsg
 
      ** Set up the qualified message file name
     C                   EVAL      MsgFileLib = #MsgFile + #MsgFLib
 
     C                   CALL      'QMHRTVM'
      **                                    Message information
     C                   PARM                    MsgInfo
      **                                    Length of message information
     C                   PARM                    LenMsgInf
      **                                    Format name
     C                   PARM                    FormatName
      **                                    Message identifier
     C                   PARM                    #MsgID
      **                                    Qualified message file name
     C                   PARM                    MsgFileLib
      **                                    Replacement data
     C                   PARM                    #MsgData
      **                                    Length of replacement data
     C                   PARM                    LenRepData
      **                                    Replace substitution variables
     C                   PARM                    RepSubVal
      **                                    Return format control characters
     C                   PARM                    RtnFmtCtrl
      **                                    Error code
     C                   PARM                    QUSEC
 
 
      ** Put the returned data into the string to return to the caller
     C                   SELECT
      **                 ------
 
      ** If the Level field is zero, return the first and second
      ** level texts
     C                   WHEN          Level = '0'
     C                   EVAL          CompMsg = QMHSSAGE02
 
      ** If Level is 1, return only the first-level text
     C                   WHEN          Level = '1'
 
      ** The length message returned field (QMHLMRTN02) contains the actual
      ** length of the first-level text, which is what we want to return,
      ** rather than the whole first-level field (the 'Message' field
      ** actually can contain all of the first-level text plus some of the
      ** second-level).
     C                   EVAL          CompMsg =
     C                                 %SUBST(QMHSSAGE02 : 1 : QMHLMRTN02)
 
      ** If Level is 2, return only the second-level text
     C                   WHEN          Level = '2'
 
      ** Similarly to first-level only, above, for second-level only we
      ** have to get the part of the second-level text that is in the
      ** 'Message' field, and add it to the 'Message help' field.
     C                   EVAL          CompMsg =
     C                                 %SUBST(QMHSSAGE02 : QMHLMRTN02 + 1 :
     C                                 QMHLHRTN02)
 
     C                   ENDSL
 
      ***If*the*Bytes*Available*subfield*of*the*error*code*parameter************CAP003
      ***is*not*zero,*an*error*has*occured,*so*pass*control*to*the**************CAP003
      ***error*handling*subroutine.*********************************************CAP003
      ** If the Bytes Available subfield of the error code parameter            CAP003
      ** is not zero, an error has occured; return the error code to the        CAP003
      ** caller.                                                                CAP003
     C                   IF        QUSBAVL <> 0
     C*******************EVAL      RetCodeIn = 'Error'                          CAP003
     C*******************EXSR      *pssr                                        CAP003
     C                   EVAL      RetCodeIn = QUSEI                            CAP003
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned from this procedure)
     C                   PARM                    RetCodeIn
      ** Complete message (3000A, returned from this module)
     C                   PARM                    CompMsg
      ** Messgage ID (7A, from caller)
     C                   PARM                    #MsgId
      ** Message data (45A, from caller)
     C                   PARM                    #MsgData
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Library containing message file (10A, from caller)
     C                   PARM                    #MsgFLib
      ** Level of message to return (1A, from caller - 0 = both, 1 = first
      ** level only, 2 = second level only)
     C                   PARM                    Level
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001

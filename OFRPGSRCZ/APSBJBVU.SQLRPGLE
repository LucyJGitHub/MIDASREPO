     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF AP Submit Job')
      *****************************************************************
      *                                                               *
      *  Midas - Application Program Interface Module                 *
      *                                                               *
      *  APSBJBVU - Midas OF AP Submit Job                            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP090A            Date 04Nov13               *
      *                 CAP090   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP090A - Initiate Batch Process API                         *
      *  CAP090 - Initiate Batch Process API                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
      **-----------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction
     D TranIn        E DS                  EXTNAME(APSBJBTD)
      *
      ** Incoming Transaction
     D InfData       E DS                  EXTNAME(APSBEXTD)

     D ZMUSER          DS            17                                                      CAP090A
     D  APUSER                 1     10                                                      CAP090A
                                                                                             CAP090A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Input parameter - Program to submit
     D InProgram       S             20A
      *
      ** Input parameter - Program to submit
     D SBJBParm        S           2000A
      *
      ** Input parameter - Program to submit
     D ExtData         S            500A
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3  0
      *
     D WRun            S              1A   Inz
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   MOVEL     SBJBParm      TranIn
     C                   MOVEL     ExtData       InfData
      *
      ** Reset variables gradually updated
      *
     C                   EXSR      RESETCYCLE
      *
      ** Retrieve Program to Submit
      *
     C                   EXSR      RetrievePgm
      *
     C                   SETON                                        LR
      *
      ** Remerge buffer with all relevant data structures
      *
     C                   EVAL      Buffer = ApProcType
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Common header information (DS) from source system
      *
     C                   PARM                    HeadIn
      *
      ** Transaction information
      *
     C                   PARM                    SBJBParm
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
                                                                                             CAP090A
      ** GET ZMUSER to retrieve the user.                                                    CAP090A
                                                                                             CAP090A
     C     *DTAARA       DEFINE                  ZMUSER                                      CAP090A
     C                   IN        ZMUSER                                                    CAP090A
                                                                                             CAP090A
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      MsgFArray(1) = 'MIDAS'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RetrievePgm - Routine to retieve program to submit            *
      *                                                               *
      *****************************************************************
     C     RetrievePgm   BEGSR
      *
     C                   IF        ApProcType = *Blanks
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = ApProcType
     C**********         EVAL      MsgIDArr(Idx)  = '45046146'                               CAP090A
     C                   EVAL      MsgIDArr(Idx)  = '5046146'                                CAP090A
     C                   EVAL      MsgDtaArr(Idx)  = *Blanks
     C                   EVAL      APIRetc = 0
      *
     C                   ELSE
     C/EXEC SQL
     C+ SELECT SJPROGRAM
     C+ into :InProgram
     C+ FROM APPGMSTD
     C+ WHERE SJProcType = :ApProcType
     C/END-EXEC

     C                   SELECT
     C                   When      SQLCOD = 00 and
     C                             InProgram <> *blanks
     C                   EXSR      SUBMITPGM
      *
     C                   When      SQLCOD = 00 and
     C                             InProgram = *blanks
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SJProgram'
     C**********         EVAL      MsgIDArr(Idx)   = '45046147'                              CAP090A
     C                   EVAL      MsgIDArr(Idx)   = '5046147'                               CAP090A
     C                   EVAL      MsgDtaArr(Idx)  = *Blanks
     C                   EVAL      APIRetc = 0
      *
     C                   When      SQLCOD = 100
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '45046148'                              CAP090A
     C**********         EVAL      MsgIDArr(Idx)   = 'XXM0012'                               CAP090A
     C                   EVAL      FldNameArr(Idx) = 'SJProcType'                            CAP090A
     C                   EVAL      MsgIDArr(Idx)   = '5046148'                               CAP090A
     C                   EVAL      MsgDtaArr(Idx)  = *Blanks
     C                   EVAL      APIRetc = 0
      *
     C                   OTHER
     C                   Eval      DBFile = 'APSBJBVU'
     C                   Eval      DBKey  = 'SJProcType'
     C                   Eval      DBase  = 01
     C                   Exsr      *PSSR
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR

      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * SUBMITPGM - Routine to submit the program                      *
      *                                                                *
      ******************************************************************
     C     SUBMITPGM     BEGSR
      *
     C**********         IF        APMIDUSR <> *BLANKS                                       CAP090A
     C**********         EVAL      APUSERID =  APMIDUSR                                      CAP090A
     C**********         ELSE                                                                CAP090A
     C**********         EVAL      APUSERID =  *BLANKS                                       CAP090A
     C**********         ENDIF                                                               CAP090A
      *                                                                                      CAP090A
     C                   EVAL      APUSERID =  APUSER                                        CAP090A
      *
     C                   CALL      'APCSBJBVU'
     C                   PARM                    INPROGRAM
     C                   PARM                    APPARM1         100
     C                   PARM                    APPARM2         100
     C                   PARM                    APPARM3         100
     C                   PARM                    APPARM4         100
     C                   PARM                    APPARM5         100
     C                   PARM                    APPARM6         100
     C                   PARM                    APPARM7         100
     C                   PARM                    APPARM8         100
     C                   PARM                    APPARM9         100
     C                   PARM                    APPARM10        100
     C                   PARM                    APSBMJOB         50
     C                   PARM                    EXTDATA         500
     C                   PARM                    APUSERID         10
     C                   PARM                    FIELDNAME        10
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA           50
     C                   PARM                    IDX
     C                   PARM                    WFIELDNAM        10
     C                   PARM                    WMSGID            7
     C                   PARM                    WMSGDTA          50
     C                   PARM                    UPDATEYN          1
     C                   PARM                    BUFFER         6000
     C                   PARM                    APIRetc           3 0

     C                   If        IDX <> 0
     C                   EVAL      FldNameArr(Idx) = FIELDNAME
     C                   EVAL      MsgIDArr(Idx)   = MSGID
     C                   EVAL      MsgDtaArr(Idx)  = *BLANKS
     C                   EVAL      APIRetc = 0
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR


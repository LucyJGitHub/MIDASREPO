     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Price timestamp')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVPRTM01 - Validate Securities Prices Price Timestamp field *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CSD006  *CREATE    Date 07Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD006 - Market Data Feed                                    *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Date in DDMMYY/MMDDYY format
 
     D WTIME           S              6
     D WDATE           S              6
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Time stamp field in file format, defaulted if necessary
     D WDFTS           S             14
     D DFTS            S             14  0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
     D STAMPCHAR       S             26A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        WDFTS
     C                   MOVE      *ZEROS        DFTS
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   EXSR      SrVALSTMP
 
     C     DDDFTSOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE      WDFTS         DFTS
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SrVALSTMP - Validate Time Stamp                               *
      *                                                               *
      *****************************************************************
     C     SrVALSTMP     BEGSR
 
     C                   IF        %SUBST(DDDFTS:3:12) = *BLANKS
     C                   EVAL      DDDFTS = *BLANKS
     C                   ENDIF
 
      * Entry allowed in price timestamp field only if Data Feed Rqst ID isn't blank
 
     C                   IF        DDDFTS <> *BLANKS  AND
     C                             DDDTFR = *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1151'
     C                   EVAL      FldNamXAr(Idx) = 'DDDFTS'
     C                   EVAL      DDDFTSOK = 'N'
     C                   EVAL      DDDTFROK = 'N'
     C                   ENDIF
 
      ** Validate Date and Time if not blank
 
     C                   IF        DDDFTS <> *BLANK
 
      ** Check if date has been entered in DDMMYY or MMDDYY format
 
     C                   EVAL      WDATE  = %SUBST(DDDFTS:3:6)
 
     C                   IF        BJDFIN = 'D'
     C     *DMY0         TEST (D)                WDATE                  99
 
     C                   ELSE
 
     C     *MDY0         TEST (D)                WDATE                  99
     C                   ENDIF
 
      ** No Error on Date, validate Time
 
     C                   IF        NOT *IN99
 
      ** Time occupies positions 9 to 14
 
     C                   EVAL      WTIME = %SUBST(DDDFTS:9:6)
 
     C     *HMS0         TEST (T)                WTIME                  99
     C                   ENDIF
 
      ** Error on Date or Time validation, send error message
 
     C                   IF        *IN99
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1150'
     C                   EVAL      FldNamXAr(Idx) = 'DDDFTS'
     C                   EVAL      DDDFTSOK = 'N'
 
     C                   ELSE
 
      * No error, return data feed timestamp in file format: CCYYMMDDHHMMSS.
 
     C                   IF        BJDFIN = 'D'
 
      * Re-arrange DDMMYY format to CCYYMMDDHHMMSS
 
     C                   EVAL      WDFTS= '20'        +
     C                                    %SUBST(DDDFTS:7:2) +
     C                                    %SUBST(DDDFTS:5:2) +
     C                                    %SUBST(DDDFTS:3:2) +
     C                                    WTIME
     C                   ELSE
 
      * Re-arrange MMDDYY format to CCYYMMDDHHMMSS
 
     C                   EVAL      WDFTS= '20'        +
     C                                    %SUBST(DDDFTS:7:2) +
     C                                    %SUBST(DDDFTS:3:2) +
     C                                    %SUBST(DDDFTS:5:2) +
     C                                    WTIME
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Default timestamp to current machine date and time when not entered
      ** Only when request Id has been entered
 
     C                   IF        DDDFTS = *BLANKS AND DDDTFR <> *BLANK
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TIMESTAMP
 
     C                   MOVEL     TIMESTAMP     STAMPCHAR        26
 
     C                   EVAL      WDFTS= %SUBST(STAMPCHAR:1:4) +
     C                                    %SUBST(STAMPCHAR:6:2) +
     C                                    %SUBST(STAMPCHAR:9:2) +
     C                                    %SUBST(STAMPCHAR:12:2) +
     C                                    %SUBST(STAMPCHAR:15:2) +
     C                                    %SUBST(STAMPCHAR:18:2)
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Data Feed Timestamp
     C                   PARM                    DDDFTS           14
      ** Data Feed Request ID
     C                   PARM                    DDDTFR           32
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
 
      *  Data Feed Req Id OK flag
     C                   PARM                    DDDTFROK          1
      *  Data Feed Timestamp OK flag
     C                   PARM                    DDDFTSOK          1
      ** Data Feed Timestamp, file format
     C                   PARM                    DFTS
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEVPRMT01'   DBPGM
     C                   OUT       LDA
      *
      * Access Bank details via access program
      * (database error handling done in access program).
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Set up the name of the MSGF from which the message handler will
      *  obtain the messages.
      *
     C                   EVAL      #MsgFile = 'DRSMM'
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************

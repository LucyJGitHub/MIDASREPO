     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Read')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPRED - CLS Pay-in Schedule Read                         *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the CLS Pay-in Schedule files             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** CLS Pay-in Schedule Header file - all deals
     FFXCLSPSHL0IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXCLPHD0:TranFmt)
 
      ** CLS Pay-in Schedule Header file - authorised deals
     FFXCLSPSHL4IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXCLPHD0:AuthFmt)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PCcy            S              3A
     D PNost           S              2A
     D PVDate          S              6A
     D PSeq            S              2A
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMsg         S              7A
     D PCcyRed         S              3A
     D PNostRed        S              2A
     D PVDateRed       S              6A
     D PSeqRed         S              2A
 
      ** Parameters for ZVACTU
     D PZAction        S              1A
     D PErrCode        S              1P 0
 
      ** Parameters for ZDATE2
     D PZDayNo         S              5P 0
     D PZDateN         S              6P 0
     D PZADate         S              7A
 
      ** Parameter for ZAVDATE
     D PZDate          S              6A
 
      ** Key fields
     D KCcy            S              3A
     D KNost           S              2A
     D KVDate          S              5P 0
     D KSeq            S              2S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise outputs
 
     C                   EVAL      PErrMsg = *BLANKS
     C                   EVAL      PCcyRed = *BLANKS
     C                   EVAL      PNostRed = *BLANKS
     C                   EVAL      PVDateRed = *BLANKS
     C                   EVAL      PSeqRed = *BLANKS
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SrChckAut
     C                   ENDIF
 
      ** Initialise key fields
 
     C                   IF        PCcy <> *BLANKS AND
     C                             PNost <> *BLANKS AND
     C                             PVDate <> *BLANKS AND
     C                             PSeq <> *BLANKS
     C                   MOVEL     PCcy          KCcy
     C                   MOVEL     PNost         KNost
     C                   MOVE      PVDate        PZDate
     C                   EXSR      SrZAVDate
     C                   Z-ADD     PZDayNo       KVDate
     C                   MOVEL     PSeq          KSeq
     C                   ENDIF
 
      ** Read forwards
 
     C                   IF        PRdFwd = 'Y'
     C                   EXSR      SrRdFwd
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PRdBck = 'Y'
     C                   EXSR      SrRdBck
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input parameters :
 
      ** Return code
     C                   PARM                    RetCodeIn
      ** Action code
     C                   PARM                    ActionCode
      ** Currency
     C                   PARM                    PCcy
      ** Nostro code
     C                   PARM                    PNost
      ** Value date
     C                   PARM                    PVDate
      ** Sequence number
     C                   PARM                    PSeq
      ** Read forwards
     C                   PARM                    PRdFwd
      ** Read backwards
     C                   PARM                    PRdBck
 
      ** Output Parameters :
 
      ** Error meassage
     C                   PARM                    PErrMsg
      ** Currency read
     C                   PARM                    PCcyRed
      ** Nostro Number read
     C                   PARM                    PNostRed
      ** Value Date read
     C                   PARM                    PVDateRed
      ** CLS Sequence Number read
     C                   PARM                    PSeqRed
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'FXCLSPRED'
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise key fields
 
     C     KHeader       KLIST
     C                   KFLD                    KCcy
     C                   KFLD                    KNost
     C                   KFLD                    KVDate
     C                   KFLD                    KSeq
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdFwd - Read forwards through CLS Pay-in Schedule Header    *
      *****************************************************************
     C     SrRdFwd       BEGSR
 
      ** Position to current record on file
 
     C                   IF        ActionCode = 'X'
     C     KHeader       SETGT     AuthFmt
     C                   ELSE
     C     KHeader       SETGT     TranFmt
     C                   ENDIF
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN87 = '1' OR
     C                             PErrCode = *ZERO
 
      ** Read next transaction
 
     C                   IF        ActionCode = 'X'
     C                   READ      AuthFmt                                87
     C                   ELSE
     C                   READ      TranFmt                                87
     C                   ENDIF
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN87 = '1'
 
     C                   IF        PCcy = *BLANKS AND
     C                             PNost = *BLANKS AND
     C                             PVDate = *BLANKS AND
     C                             PSeq = *BLANKS
     C                   EVAL      PErrMsg = 'MMM1006'
     C                   ELSE
     C                   EVAL      PErrMsg = 'MMM1002'
     C                   ENDIF
 
      ** Else, return the transaction reference read
 
     C                   ELSE
     C                   MOVEL     PYCCY         PCcyRed
     C                   MOVEL     PYNOST        PNostRed
     C                   Z-ADD     PYVALD        PZDayNo
     C                   EXSR      SrZDate2
     C                   MOVE      PZDateN       PVDateRed
     C                   MOVEL     PYSEQN        PSeqRed
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdBck - Read backwards through CLS Pay-in Schedule Header   *
      *****************************************************************
     C     SrRdBck       BEGSR
 
      ** Position to current record on file
 
     C                   IF        ActionCode = 'X'
     C     KHeader       SETLL     AuthFmt
     C                   ELSE
     C     KHeader       SETLL     TranFmt
     C                   ENDIF
 
      ** Read until start of file or a valid record is found or an error
 
     C                   DOU       *IN87 = '1' OR
     C                             PErrCode = *ZERO
 
      ** Read previous transaction
 
     C                   IF        ActionCode = 'X'
     C                   READP     AuthFmt                                87
     C                   ELSE
     C                   READP     TranFmt                                87
     C                   ENDIF
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN87 = '1'
     C                   EVAL      PErrMsg = 'MMM1003'
 
      ** Else, return the transaction reference read
 
     C                   ELSE
     C                   MOVEL     PYCCY         PCcyRed
     C                   MOVEL     PYNOST        PNostRed
     C                   Z-ADD     PYVALD        PZDayNo
     C                   EXSR      SrZDate2
     C                   MOVE      PZDateN       PVDateRed
     C                   MOVEL     PYSEQN        PSeqRed
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrChckAut - Check for user authority if not multi-branching   *
      *****************************************************************
     C     SrChckAut     BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PZAction
     C                   PARM                    PErrCode
 
     C                   IF        PErrCode = 1
     C                   EVAL      PErrMsg = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate2 - Format a date for output                          *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDateN
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZAVDate - Format a date for output                         *
      *****************************************************************
     C     SrZAVDate     BEGSR
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PZDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDayNo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTUPD - Document Management Details Update               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Document Management Details File
     FSDDCMTL1  UF A E           K DISK
     F                                     COMMIT
 
      ** Document Management Comments History Details File
     FSDDMCHPD  O    E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
 
      /COPY ZACPYSRC,PSDS
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** New Document Code detail File Format
     D NwDcFilFmt    E DS                  Extname(SDVDCMTPD)
 
      ** Document Management details
     D SDDCMTF       E DS                  EXTNAME(SDDCMTPD)
 
      ** Document Management details
     D SDDCMTFM      E DS                  EXTNAME(SDDCMTPD)
     D                                     PREFIX(CH)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details for Timestamp checking
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D WDTMST          DS
     D  WWYr                   1      4
     D  WWMn                   5      6
     D  WWDy                   7      8
 
     D WTTMST          DS
     D  WWHH                   1      2
     D  WWMM                   3      4
     D  WWSS                   5      6
 
     D ZMUSER          DS            17
     D  WUSRID                 1     10
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PTimeStamp      S             26Z
     D PRetCode        S              7A
     D WSEQN           S              3S 0
     D WWTMST          S             26A
     D WRHIST          S              1A   INZ('N')
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * ZDATE10 parms
     D PDateIn         S              8S 0
     D PMDNO           S              5P 0
 
     D WKUSER          S             10A
     D PMTMST          S             26Z
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
 
     C                   EXSR      SRChkOthUpd
 
     C                   IF        RetCodeIn <> *Blanks
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Retrieve ZMUSER details.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
     C                   IF        PSUSER = 'QUSER'
     C                   EVAL      WKUSER = WUSRID
     C                   ELSE
     C                   EVAL      WKUSER = PSUSER
     C                   ENDIF
 
      ** Insert or amend of Document Code
 
     C                   SELECT
 
     C                   WHEN      DVLTYP = 'I'
     C                   EXSR      SrDocIn
 
     C                   WHEN      DVLTYP = 'A'
     C                   EXSR      SrDocAm
 
     C                   WHEN      DVLTYP = 'D'
     C                   EXSR      SrDocDl
 
     C                   ENDSL
 
      ** Exit From Program
     C     EXIT          TAG
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCHKOTHUPD - Check for update by another workstation         *
      *                                                               *
      *****************************************************************
 
     C     SrCHKOTHUPD   BEGSR
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn           6
     C                   PARM                    PType             1
 
      ** Set retrieve mode to blank (Access using Midas transaction ID)
 
     C     PType         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeofOp
     C                   END
 
     C                   CALLB     'SDDCMTRTV'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp          6
     C                   PARM      ' '           RespMode          1
     C                   PARM                    PMODE             1
     C                   PARM      DVLTYP        DDACTN            1
     C                   PARM      DVREFN        DDREFN           10
     C                   PARM      DVRTYP        DDRTYP           10
     C                   PARM      DVCODE        DDCODE            2
     C                   PARM      DVSEQN        WSEQN
     C                   PARM      DVFOID        FOTRID           20
     C                   PARM                    SDDCMTFM
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDREFNOK          1
     C                   PARM                    DDCODEOK          1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx               3 0
     C                   PARM                    DDNARR           30
 
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C     PType         IFEQ      '1'
 
     C     CHDMTMST      IFNE      DVTMST
     C                   MOVEL     '*RECUPD'     PRetCode
     C                   END
 
      ** Batch mode:
     C                   ELSE
     C     DDACTNOK      IFEQ      'N'
     C     DDREFNOK      OREQ      'N'
     C     DDCODEOK      OREQ      'N'
     C                   MOVEL     '*RECUPD'     PRetCode
     C                   Z-ADD     1             C                 2 0
 
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDocIn - Insert Document Code details                       *
      *                                                               *
      *****************************************************************
 
     C     SrDocIn       BEGSR
 
      ** Assign Sequence number for new Document Code
 
     C     KCODE         SETGT     SDDCMTL1                           99
     C     KCODE         READPE    SDDCMTL1
     C                   IF        %EOF(SDDCMTL1)
     C                   EVAL      DVSEQN = 1
     C                   ELSE
     C                   EVAL      DVSEQN = DMSEQN + 1
     C                   ENDIF
 
     C                   CLEAR                   SDDCMTF
 
     C                   EVAL      DMREFN = DVREFN
     C                   EVAL      DMRTYP = DVRTYP
     C                   EVAL      DMCODE = DVCODE
 
     C                   EVAL      DMSEQN = DVSEQN
 
     C                   EVAL      DMDREF = DVDREF
     C                   EVAL      DMSTCD = DVSTCD
     C                   EVAL      DMISCT = DVISCT
     C                   EVAL      DMISDT = DVISDT
     C                   EVAL      DMEXDT = DVEXDT
     C                   EVAL      DMRQDT = DVRQDT
     C                   EVAL      DMRCDT = DVRCDT
     C                   EVAL      DMREJC = DVREJC
     C                   EVAL      DMREQB = DVREQB
     C                   EVAL      DMCOMM = DVCOMM
     C                   EVAL      DMIMGE = DVIMGE
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PMTMST
 
     C                   MOVEL     PMTMST        DMTMST
 
      ** Update Comment User, Date and Time if Comment changed
 
     C                   IF        DVCOMM <> *BLANKS
     C                   MOVE      DMTMST        WWTMST
     C                   EVAL      WWYr = %SUBST(WWTMST:01:4)
     C                   EVAL      WWMn = %SUBST(WWTMST:06:2)
     C                   EVAL      WWDy = %SUBST(WWTMST:09:2)
     C                   MOVEL     WDTMST        PDateIN
     C                   EXSR      SrZDAT10
     C                   EVAL      DMCDAT = PMDNO
     C                   EVAL      WWHH = %SUBST(WWTMST:12:2)
     C                   EVAL      WWMM = %SUBST(WWTMST:15:2)
     C                   EVAL      WWSS = %SUBST(WWTMST:18:2)
     C                   MOVE      WTTMST        DMCTIM
     C                   EVAL      DMCUSR = WKUSER
     C                   ENDIF
 
     C                   EVAL      DMLTYP = 'I'
     C                   EVAL      DMLCDT = BJRDNB
     C                   EVAL      DMREPA = DVREPA
     C                   EVAL      DMFOID = DVFOID
     C                   EVAL      DMLUSR = WKUSER
 
     C                   WRITE     SDDCMTD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDocAm - Amend Document Code details                        *
      *                                                               *
      *****************************************************************
 
     C     SrDocAm       BEGSR
 
      ** Check first if the record exists.
 
 
     C     KDCMT         CHAIN     SDDCMTL1
 
     C                   IF        NOT %FOUND(SDDCMTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDDCMTPD'
     C                   EVAL      DBKey = DVREFN + DVCODE
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** Write to Comments History fields if Comment changes
 
     C                   EVAL      WRHIST = 'N'
     C                   IF        DMCOMM <> DVCOMM
     C                             AND DMCOMM <> *BLANKS
 
     C                   EVAL      WRHIST = 'Y'
     C                   EVAL      CHCOMM = DMCOMM
     C                   EVAL      CHREFN = DMREFN
     C                   EVAL      CHRTYP = DMRTYP
     C                   EVAL      CHCODE = DMCODE
     C                   EVAL      CHSEQN = DMSEQN
     C                   EVAL      CHCUSR = DMLUSR
 
     C                   MOVE      *BLANKS       WWTMST
     C                   MOVE      DMTMST        WWTMST
     C                   EVAL      WWYr = %SUBST(WWTMST:01:4)
     C                   EVAL      WWMn = %SUBST(WWTMST:06:2)
     C                   EVAL      WWDy = %SUBST(WWTMST:09:2)
     C                   MOVEL     WDTMST        PDateIN
     C                   EXSR      SrZDAT10
     C                   EVAL      CHCDAT = PMDNO
     C                   EVAL      WWHH = %SUBST(WWTMST:12:2)
     C                   EVAL      WWMM = %SUBST(WWTMST:15:2)
     C                   EVAL      WWSS = %SUBST(WWTMST:18:2)
     C                   EVAL      CHCTIM = WTTMST
     C                   ENDIF
 
      ** Update 'Before Image'.
 
     C                   EVAL      DMREFN = DVREFN
     C                   EVAL      DMRTYP = DVRTYP
     C                   EVAL      DMCODE = DVCODE
     C                   EVAL      DMSEQN = DVSEQN
     C                   EVAL      DMDREF = DVDREF
     C                   EVAL      DMSTCD = DVSTCD
     C                   EVAL      DMISCT = DVISCT
     C                   EVAL      DMISDT = DVISDT
     C                   EVAL      DMEXDT = DVEXDT
     C                   EVAL      DMRQDT = DVRQDT
     C                   EVAL      DMRCDT = DVRCDT
     C                   EVAL      DMREJC = DVREJC
     C                   EVAL      DMREQB = DVREQB
 
     C                   EVAL      DMLTYP = 'A'
     C                   EVAL      DMLUSR = WKUSER
     C                   EVAL      DMLCDT = BJRDNB
 
      ** Get timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PMTMST
 
     C                   MOVEL     PMTMST        DMTMST
 
      ** Update Comment Details when comment changed
 
     C                   IF        DMCOMM <> DVCOMM
     C                   MOVE      *BLANKS       WWTMST
     C                   MOVE      DMTMST        WWTMST
     C                   EVAL      WWYr = %SUBST(WWTMST:01:4)
     C                   EVAL      WWMn = %SUBST(WWTMST:06:2)
     C                   EVAL      WWDy = %SUBST(WWTMST:09:2)
     C                   MOVEL     WDTMST        PDateIN
     C                   EXSR      SrZDAT10
     C                   EVAL      DMCOMM = DVCOMM
     C                   EVAL      DMCUSR = WKUSER
     C                   EVAL      DMCDAT = PMDNO
     C                   EVAL      WWHH = %SUBST(WWTMST:12:2)
     C                   EVAL      WWMM = %SUBST(WWTMST:15:2)
     C                   EVAL      WWSS = %SUBST(WWTMST:18:2)
     C                   MOVE      WTTMST        DMCTIM
     C                   ENDIF
 
     C                   EVAL      DMIMGE = DVIMGE
 
      ** Update Document Management Detail File
     C                   UPDATE    SDDCMTD0
 
      ** Write to Comments History File
     C                   IF        WRHIST = 'Y'
     C                   WRITE     SDDMCHD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDocDl - Delete Document Code Details                       *
      *                                                               *
      *****************************************************************
 
     C     SrDocDl       BEGSR
 
      ** Check first if the record exists.
 
     C     KDCMT         CHAIN     SDDCMTL1
 
     C                   IF        NOT %FOUND(SDDCMTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDDCMTPD'
     C                   EVAL      DBKey = DVREFN + DVCODE
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete Record
     C                   DELETE    SDDCMTD0
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrZDAT10 - Convert YYYYMMDD Date to Midas Day                *
      *                                                               *
      *****************************************************************
 
     C     SrZDAT10      BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM                    PMDNO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** New Details in File Format
     C                   PARM                    NwDcFilFmt
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C     KDCMT         KLIST
     C                   KFLD                    DVREFN
     C                   KFLD                    DVRTYP
     C                   KFLD                    DVCODE
     C                   KFLD                    DVSEQN
 
     C     KCODE         KLIST
     C                   KFLD                    DVREFN
     C                   KFLD                    DVRTYP
     C                   KFLD                    DVCODE
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   EVAL      DBFILE    = 'SDBANKPD'
     C                   EVAL      DBASE     = 901
     C                   EVAL      DBKEY     = '*FIRST  '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************
 
     C     SRErr         BEGSR
 
     C                   EVAL      PRetCode = '*ERROR '
     C                   EVAL      DBPGM = 'SDDCMTUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the Program
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013

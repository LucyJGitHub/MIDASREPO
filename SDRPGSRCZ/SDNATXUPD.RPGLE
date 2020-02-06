     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Update')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXUPD - SD Customer Details by Country of Tax Update     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233295             Date 29Apr05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Non-Account Holder by Country of Tax - Update
     F***SDNHTXL0  UF A E           K Disk    Commit                                          233295
     FSDNHTXL5  UF A E           K DISK    COMMIT                                             233295
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
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
 
      ** New Details in File Format
     D NwFilFmt      E DS                  Extname(SDVNATXPD)
 
      ** Custumer Details by Country of Tax File Format
     D NHTXFilFmt    E DS                  Extname(SDNHTXPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
 
      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters                                                                     233295
     D PActn           S              1A                                                      233295
                                                                                              233295
      ** Timestamp
     D PTimeStamp      S             26Z
 
      ** Fields defined for Calling SDNATXLOG
 
     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PNahoNum        S             18A
     D PANahoNo        S             18A
     D P@Timestamp     S             26A
     D PSard           S              6A
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D P@Rtcd          S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
     C     KEY1          KLIST
     C                   KFLD                    NTNAHO
     C                   KFLD                    NTCTTX
 
     C*****KEY1*         CHAIN     SDNHTXL0                           10                      233295
     C     KEY1          CHAIN     SDNHTXL5                           10                      233295
 
     C                   IF        PActn = 'D'                                                233295
                                                                                              233295
     C                   IF        *IN10 = *OFF                                               233295
     C                   DELETE    SDNHTXD0                             20                    233295
                                                                                              233295
     C                   IF        *IN20 = *ON                                                233295
     C                   EVAL      RetCodeIn = '*ERROR'                                       233295
     C     *LOCK         IN        LDA                                                        233295
     C                   EVAL      DBFile = 'SDNHTXPD'                                        233295
     C                   EVAL      DBKey = NTNAHO + NTCTTX                                    233295
     C                   EVAL      DBase = 101                                                233295
     C                   OUT       LDA                                                        233295
     C                   EXSR      *PSSR                                                      233295
     C                   ENDIF                                                                233295
                                                                                              233295
     C                   ENDIF                                                                233295
                                                                                              233295
     C                   ELSE                                                                 233295
                                                                                              233295
      ** Generate Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
      ** Translate records to file layout
 
     C                   EVAL      NTTMST = PTimestamp
 
     C                   EVAL      NHTXFilFmt = NwFilFmt
 
     C                   IF        *IN10 = *OFF
     C                   UPDATE    SDNHTXD0                             20
 
     C                   IF        *IN20 = *ON
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDNHTXPD'
     C                   EVAL      DBKEY = NTNAHO + NTCTTX
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   WRITE     SDNHTXD0
     C                   ENDIF
                                                                                              233295
     C                   ENDIF                                                                233295
 
      ** If 24x7 Midas Availability is installed
      ** and Support System is active
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
 
     C                   CALLB     'SDNATXLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NHTXFilFmt
     C                   PARM                    TRANSDTL
 
      ** If there is no error, write the log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'SDNATX'
     C                   EVAL      APFOTRANID = NTFRNT
     C                   EVAL      APRPRLOCN  = NTREPA
     C                   EVAL      APUSERID   = PSUser
     C                   EVAL      APMIDUSR   = PSUser
 
     C                   MOVEL     NTNaho        PNahoNum
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       P@Timestamp
     C                   PARM                    PNahoNum
     C                   PARM      *BLANKS       PANahoNo
 
     C                   ENDIF
 
      ** If there is an error in either log file, end program
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      P@RTCD = '*ERROR'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * Input Parameters :
 
      ** Return Code
      ** Action Code                                                                          233295
      ** New Details in File Format
     C                   PARM                    RetCodeIn
     C                   PARM                    PActn                                        233295
     C                   PARM                    NwFilFmt
 
      ** Check if CSC011 is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************
 
     C     SRErr         BEGSR
 
     C                   EVAL      P@Rtcd = '*ERROR '
     C                   EVAL      DBPGM = 'SDNATXUPD'
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
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004

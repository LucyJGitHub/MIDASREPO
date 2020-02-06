     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holders Set up')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000779 - SD Country of Tax Set up for Non-Account Holders  *
      *             Take on                                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Country of Tax Codes - Rtv Idx
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Non-A/C Holders - Rtv Idx
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Non-account Holders by Country of Tax - Rtv Idx
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDNHTXD0:SDNHTXD1)
 
      ** Midas SD Non-account Holders by Country of Tax
     FSDNHTXPD  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Data Structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
 
      ** Key List
     D KCust           S             10A
     D KCctx           S              2A
 
     D WPrevCTRT       S              2A
     D CSC011          S              1A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C     *LOVAL        SETLL     SDNAHOL1
     C                   READ      SDNAHOL1
 
     C                   DOW       NOT %EOF(SDNAHOL1)
 
     C                   IF        NHPIND = 'Y'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   READ      SDNAHOL1
     C                   ENDDO
 
      **  Exit From Program
 
     C                   EVAL      *INLR = *ON
      ****************************************************************
      * Program End
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRProcess - Update to SDNHTXPD                               *
      *                                                              *
      ****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Access with Country of Location
 
     C     NHCOLC        SETLL     SDCTTXL2
     C     NHCOLC        READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C                   READ      SDCTTXL2
     C                   ENDDO
 
      ** Access without Country of Location
 
     C                   EVAL      NHCOLC = *Blanks
     C     NHCOLC        SETLL     SDCTTXL2
     C     NHCOLC        READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C                   READ      SDCTTXL2
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWrite  - Write details                                     *
      *                                                              *
      ****************************************************************
     C     SRWrite       BEGSR
 
     C                   CLEAR                   SDNHTXD0
 
     C                   EVAL      KCust = NHNAHO
     C                   EVAL      KCctx = EWCTRT
     C     KNHTX         CHAIN     SDNHTXL1
 
     C                   IF        NOT %FOUND(SDNHTXL1)
     C                   EVAL      NXNAHO = NHNAHO
     C                   EVAL      NXCTTX = EWCTRT
     C                   EVAL      NXETXS = EWTXS1
     C                   EVAL      NXCERF = *BLANKS
     C                   EVAL      NXCEEX = *ZEROS
     C                   EVAL      NXREPI = *BLANKS
     C                   EVAL      NXFRNT = *BLANKS
     C                   EVAL      NXREPA = *BLANKS
 
      ** If CSC011 is installed, supply a Front Office ID
 
     C                   IF        CSC011 = 'Y' And
     C                             NXFRNT = *BLANKS
     C                   EVAL      NXFRNT = 'MD' + NXNAHO + NXCTTX
     C                   ENDIF
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      NXTMST = TimeStamp
 
      ** Write details
 
     C                   WRITE     SDNHTXD0
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List
 
     C     KNhtx         KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCctx
 
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
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2004

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Initialization Program for CSE065')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE000007 - Midas SE Initialization Program for CSE065        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065  *CREATE    Date 08Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SE Securities details
     FSECTI     UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Investment Types
     FINVTP     IF   E           K DISK
 
      ** Midas SE Security Events By Type
     FSECET     IF   E           K DISK
 
      ** Midas SE Security Diary Events - Audit
     FSEDEVA    UF   E             DISK    INFSR(*PSSR)
 
      ** Midas SE Security Events Diary
     FSEDEVD    O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD1)
     F                                     PREFIX(X)
 
      ** Midas SE CSE065 Initialization Audit Report
     FSE000007AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Objects
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D W@SecRd         S              5S 0
     D W@SecDA         S              5S 0
     D POPTN           S              7
     D PRTCD           S              7
 
      ** File Information Data Structure for SE0007AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OfLin                188    189B 0
     D  PrtLin               367    368B 0
 
      ** Parameters for ZA0140M
 
     D P@Rtn           S              1A
     D P@DayN          S              5P 0
     D P@DFmt          S              1A
     D P@Date          S              6S 0
     D P@Data          S              7A
     D P@Dat8          S              8S 0
     D P@Dat8F         S              8S 0
 
      ** Work Variables
 
     D WRun            S              1A
     D Wrqdln          S              3S 0
     D Wdifln          S              3S 0
     D W@End           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRINIT - Initialization Routine                              *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Database error processing
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SE0000007'   DBPGM
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise report work fields.
      *
     C                   Z-ADD     0             Wrqdln
     C                   Z-ADD     0             Wdifln
      *
     C                   EVAL      W@End = 'N'
      *
     C     *LIKE         DEFINE    SDSN          K@ScNm
     C     *LIKE         DEFINE    SDET          K@DEvTy
     C     *LIKE         DEFINE    SDED          K@DEvDt
      *
     C     INVKEY        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
      *
     C     SECKEY        KLIST
     C                   KFLD                    K@ScNm
     C                   KFLD                    K@DEvTy
     C                   KFLD                    K@DEvDt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPROC - Process details                                     *
      *****************************************************************
     C     SRPROC        BEGSR
      *
      ** Read through SECTI File
      *
     C     *LOVAL        SETLL     SECTI
     C                   READ      SECTI                                  90
      *
     C                   IF        *IN90 = *ON
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
     C                   DOW       *IN90 = *OFF
      *
     C                   ADD       1             W@SecRd
      *
     C     INVKEY        CHAIN     INVTP                              91
     C                   IF        *IN91 = *ON
      *
      ** Database Error
      *
     C                   EXSR      SRINVER
     C                   ELSE
      *
      ** Update ALDT in SECTYD
      *
     C                   EXSR      SRUPDA
      *
     C                   MOVEL     SESN          K@ScNm
     C                   MOVE      'AL'          K@DEvTy
     C                   MOVE      *ZEROS        K@DEvDt
     C
     C     SECKEY        CHAIN     SECET                              92
     C                   IF        *IN92 = *ON
     C                             AND PROT <> '2'
     C                             AND PROT <> '4'
     C                             AND PROT <> '7'
      *
      ** Write to SEDEVD
      *
     C                   EXSR      SRWRTSED
      *
      ** Write details to Audit Report
      *
     C                   EXSR      SRWAUD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SECTI                                  90
      *
     C                   ENDDO
      *
      ** Update Diary Events
     C                   EXSR      SRUPDS
      *
     C                   Z-ADD     W@SecRd       RTOSEC
     C                   Z-ADD     W@SecDA       RTOSED
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     6             Wrqdln
     C     OfLin         SUB       PrtLin        Wdifln
     C     Wdifln        IFLE      Wrqdln
     C                   WRITE     HEADAU
     C                   ENDIF
      *
     C                   WRITE     TOTALS
      *
     C                   WRITE     ENDREP
     C                   EVAL      W@End = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAUDT - Output audit report and end program                 *
      *****************************************************************
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   IF        W@End = 'N'
     C                   Z-ADD     6             Wrqdln
     C     OfLin         SUB       PrtLin        Wdifln
     C     Wdifln        IFLE      Wrqdln
     C                   WRITE     HEADAU
     C                   ENDIF
     C                   ENDIF
      *
      ** If there is a DB error, output the DB error information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, output "No Details" message.
      *
     C     W@SecRd       IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End program and return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUPDA - Subroutine to update ALDT in SECTYD                 *
      *****************************************************************
     C     SRUPDA        BEGSR
      *
     C                   IF        ALDT = *ZEROS
     C                             AND PROT <> '2'
     C                             AND PROT <> '4'
     C                             AND PROT <> '7'
     C                   Z-ADD     MATY          ALDT
     C                   UPDATE    SECTYDF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWRTSED - Write to SEDEVD                                   *
      *****************************************************************
     C     SRWRTSED      BEGSR
      *
     C                   CLEAR                   SEDEVD1
      *
     C                   EVAL      XRECI = 'M'
     C                   EVAL      XSDSN = SESN
     C                   EVAL      XSDED = *ZEROS
     C                   EVAL      XSDET = 'AL'
     C                   EVAL      XSDNV = 'INITIAL VALUE'
     C                   EVAL      XSDAL = MATY
      *
     C                   WRITE     SEDEVD1
      *
     C                   ADD       1             W@SecDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWAUD - Write to Audit Report                               *
      *****************************************************************
     C     SRWAUD        BEGSR
      *
      ** Check if sufficient lines remain for the format. If not,
      ** write header on a new page.
      *
     C                   Z-ADD     6             Wrqdln
     C     OfLin         SUB       PrtLin        Wdifln
     C     Wdifln        IFLE      Wrqdln
     C                   WRITE     HEADAU
     C                   ENDIF
      *
     C                   CALLB     'ZA0140M'
     C                   PARM      *BLANK        P@Rtn
     C                   PARM      ALDT          P@DayN
     C                   PARM      BJDFIN        P@DFmt
     C                   PARM                    P@Date
     C                   PARM                    P@Data
     C                   PARM                    P@Dat8
     C                   PARM                    P@Dat8F
      *
     C                   MOVE      P@DATA        RALDT
      *
      ** Write Detail Record
      *
     C                   WRITE     DETAILS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINVER- Database Error, Not Found in INVTP                   *
      *****************************************************************
     C     SRINVER       BEGSR
      *
      ** Check if sufficient lines remain for the format. If not,
      ** write header on a new page.
      *
      *
     C                   Z-ADD     6             Wrqdln
     C     OfLin         SUB       PrtLin        Wdifln
     C     Wdifln        IFLE      Wrqdln
     C                   WRITE     HEADAU
     C                   ENDIF
      *
     C                   MOVEL     SESN          RERSEC
      *
     C                   WRITE     DBERR1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUPDS - Midas SE Security Diary Events - Audit              *
      *****************************************************************
     C     SRUPDS        BEGSR
      *
     C                   READ      SEDEVA
      *
     C                   ADD       W@SecDA       NOIN
     C                   ADD       W@SecDA       NORE
      *
     C                   UPDATE    SEDEVAF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2004

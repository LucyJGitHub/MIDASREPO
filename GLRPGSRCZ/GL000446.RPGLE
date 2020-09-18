     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Upd Nost Proj with Consumer Banking nost proj')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000446  - Update Nostro Projections                        *
      *                                                               *
      *  Function:  Update Nostro Projections with Consumer           *
      *             Banking Nostro Projections                        *
      *                                                               *
      *  Called By: GLC000446 - Update Nostro Projections             *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14826A          Date 13Sep07               *
      *                 BUG14597           Date 14Aug07               *
      *                 BUG14589           Date 10Aug07               *
      *                 BG12067            Date 23Nov06               *
      *                 BG12134            Date 30Sep06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14826A - Transactions made using Equation functions were  *
      *      not reflected in the Projected Nostro Balances Enquiry   *
      *  BUG14597 - RSACMTPD generates Invalid CUSN, ACSQ, BRCA       *
      *  BUG14589 - Transactions made using Equation functions were   *
      *      not reflected in the Projected Nostro Balances Enquiry   *
      *  BG12067 - Skip transactions where equation nostro is not in  *
      *            SDNOSTPD and MEMO file should be updated only for  *
      *            Retail Nostro Accounts                             *
      *  BG12134 - Remove RCF processing for audit file               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E  I N D E X                                *
      *                                                               *
      **SRTMPF*-*Subroutine*to*Read*the*AF6PF*file*********************                      BG12067
      * SRTMPF - Subroutine to Read the AF610LF file                  *                      BG12067
      * SRRCFA - Subroutine to Register GL0446AU via RCF              *
      * SRUPDLM - Subroutine to Update Projected Nostro Accounts      *
      *           Control file                                        *
      * SRNOST - Subroutine to Validate Nostro Code                   *
      * CVTDATE - Subroutine to Validate and Convert Date             *
      *           into Day Number                                     *
      * SRAUDT - Subroutine to Output Audit report and End Program    *
      * UPDNSSHD - Subroutine to Update the Account Shadow            *
      *            Balances File                                      *
      * UPDRLMVT - Subroutine to Update the Real Time Account         *
      *            Movements File                                     *
      * PROJAM - Subroutine to Update the Nostro Projections File     *
      * *PSSR - Program exception error routine                       *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *Time Table File
     F*AF6PF**** IF   E             DISK    INFSR(*PSSR)                                     BG12067
     FAF610LF   IF   E           K DISK    INFSR(*PSSR)                                      BG12067
     F                                     USROPN
 
      *Projected Nostro Account Movements File
     FAF710LF   UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
 
      *Projected Nostro Accounts Control file
     F*GLNOSTPD* UF   E             DISK    INFSR(*PSSR)                                     BG12067
     FGLNOSTPD  UF A E             DISK    INFSR(*PSSR)                                      BG12067
     F                                     USROPN
     F                                     COMMIT
 
      *Extract Audit Report Print File
     FGL000446AUO    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN99)
     F**********                           INFDS(SPOOLU)                                     BG12134
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D*SVALKK***       C                   CONST('ConsumerBankingNarr')                     BUG14589
     D SVALCB          C                   CONST('CB')                                      BUG14589
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Compile time Array
     D CMDDLY          S             80    DIM(1) PERRCD(1) CTDATA
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ***SPOOL*Information*Data*Structure*for*ZSFILE*******************                      BG12134
     D*SPOOLU***       DS                                                                    BG12134
     D*SFILEU***              83     92                                                      BG12134
     D*SFNUMU***             123    124B 0
 
      ** Projected Nostro Accounts Job Control Dataarea Layout File
     D GLNOSTCTL     E DS                  EXTNAME(GLNOSTCTL)
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** Data structure for Account Movements file
     D RSACMT        E DS                  EXTNAME(RSACMTPD)
     D                                     PREFIX(RS)
 
      ** Data structure
     D SVAL1           DS           200
     D SVAL11                  1      2
 
      ** Data structure for Midas SD Narrative codes
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
                                                                                             BG12067
      ** Data structure for Account Details File                                             BG12067
     D SDACNT        E DS                  EXTNAME(ACCNTAB)                                  BG12067
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variable For Timestamp Field
     D O_TIMESTAMP     S             26    INZ
 
      ** Work Variables For Sequence Number
     D TSEQNO          S              7  0
     D LSEQNO          S              7  0
 
      ** Parameters For QCMDEXC
     D CMDLEN          S             15  5
     D DLYJOB          S             80A
 
      ** Parameters For ZSFILE
     D PZSNUM          S              6  0
     D PSEQ            S              5A
     D PSENTY          S              3A
     D PZSERR          S              1A
 
      ** Parameters For ZDATE1
     D @ERRFLAG        S              1A
     D DATEIN          S              6
     D DAYNOOUT        S              5P 0
 
      ** Common Parameters For AORSACW0,AOBANKR0,AONOSTR0,AOMEMSU0,AOSVALR0
     D @RTCD           S              7A
     D @OPTN           S              7A
     D MAMT            S             15  0
     D VALDATE         S              5P 0
 
      ** Parameters For AONOSTR0
     D P@CUST          S              6A
     D P@CYCD          S              3A
     D P@ACCD          S             10A
     D P@ACSN          S              2A
     D P@NONB          S              2A
     D P@BRCD          S              3A
     D P@CSSN          S             10A
     D P@PNOI          S              1A
 
      ** Parameters For AOACCTR0                                                             BG12067
     D P0RETL          S             10A                                                     BG12067
     D P0CNUM          S              6A                                                     BG12067
     D P0CUCD          S              3A                                                     BG12067
     D P0ACCD          S             10A                                                     BG12067
     D P0ACSQ          S              2A                                                     BG12067
     D P0BRCA          S              3A                                                     BG12067
                                                                                             BG12067
      ** Parameters For AOMEMSU0
     D W0RETL          S             10  0
     D W0CNUM          S              6A
     D W0CUCD          S              3A
     D W0ACCD          S             10  0
     D W0ACSQ          S              2  0
     D W0BRCA          S              3A
     D W0PSTD          S              5  0
     D W0VDAT          S              5  0
     D W0AMT           S             15  0
     D W0FTOV          S              1A
 
      ** Parameters For AOSVALR0
     D SVALK1          S             20A
     D SVALK2          S             20A
     D SVAL2           S            200A
     D SVALK3          S             20A
     D SVAL3           S            200A
     D SVALK4          S             20A
     D SVAL4           S            200A
     D SVALK5          S             20A
     D SVAL5           S            200A
     D SVALK6          S             20A
     D SVAL6           S            200A
     D SVALK7          S             20A
     D SVAL7           S            200A
     D SVALK8          S             20A
     D SVAL8           S            200A
     D SVALK9          S             20A
     D SVAL9           S            200A
     D SVALK0          S             20A
     D SVAL10          S            200A
 
      ** Work Variables
     D WDATEA          S              6A
     D PSTDATE         S              5P 0
     D WNSTCD          S              5A
 
     D @RUN            S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Retrive Sequence Number From Time table File
 
     C                   EXSR      SRTMPF
 
      ** Read sequence  number From Projected Nostro Accounts
      ** Control File
 
     C                   READ(N)   GLNOSTPD
 
     C                   EVAL      LSEQNO = NOLRSN
 
      ** Read in Data Area GLNOSTCTL
 
     C                   IN        GLNOSTCTL
 
      ** Start of the main loop
 
     C**********         DOW       NOSTOP <> 'STOP' AND                                      BG12067
     C**********                   AF6TIME <> O_TIMESTAMP                                    BG12067
     C                   DOW       NOSTOP <> 'STOP'                                          BG12067
                                                                                             BG12067
     C                   IF        AF6TIME <> O_TIMESTAMP                                    BG12067
     C                   EVAL      O_TIMESTAMP = AF6TIME
 
      ** Read in Data Area GLNOSTCTL
 
     C                   IN        GLNOSTCTL
 
      ** Process till Data Area GLNOSTCTL is blank and last sequence
      ** number of Projected Nostro Accounts Control File(GLNOSTPD)
      ***is*less*than*or*equal*to*Time*table*File(AF6PF)************                         BG12067
      ** is less than or equal to Time table File(AF610LF)                                   BG12067
 
     C                   DOW       NOSTOP <> 'STOP' AND
     C                             LSEQNO <= TSEQNO
     C     LSEQNO        SETLL     AF710LF
     C     LSEQNO        READE     AF710LF
 
      ** Read in Data Area GLNOSTCTL
 
     C                   IN        GLNOSTCTL
 
      ** Process till Data Area GLNOSTCTL is blank And not the
      ** end of file(AF710LF)
 
     C                   DOW       NOSTOP <> 'STOP' AND
     C                             NOT%EOF(AF710LF)
 
      ** Execute Sub-Routine to update the Nostro Projections File
 
     C                   EXSR      PROJAM
 
      ** Read the next record from the file AF710LF with same sequence number
 
     C     LSEQNO        READE     AF710LF
 
      ** Read in Data Area GLNOSTCTL
 
     C                   IN        GLNOSTCTL
 
     C                   ENDDO
 
      ** IF end of file(AF710LF) is reached increment last processed sequence
      ** number(LSEQNO) by 1
 
     C                   IF        %EOF(AF710LF)
     C                   EVAL      LSEQNO = LSEQNO + 1
                                                                                           BUG14826A
     C                   IF        LSEQNO > NOLRSN                                         BUG14826A
                                                                                           BUG14826A
      ** Update Projected Nostro Accounts Control file                                     BUG14826A
                                                                                           BUG14826A
     C                   EXSR      SRUPDLM                                                 BUG14826A
     C                   ENDIF                                                             BUG14826A
                                                                                           BUG14826A
     C                   ENDIF
 
      ** Read in Data Area GLNOSTCTL
 
     C                   IN        GLNOSTCTL
 
     C                   ENDDO
     C                   ENDIF                                                               BG12067
                                                                                             BG12067
      ** Read in Data Area GLNOSTCTL                                                         BG12067
                                                                                             BG12067
     C                   IN        GLNOSTCTL                                                 BG12067
                                                                                             BG12067
 
      ** If STOP is not encountered delay the job by 30 seconds
 
     C                   IF        NOSTOP <> 'STOP'
 
     C                   MOVEA     CMDDLY(1)     DLYJOB
     C                   EVAL      CMDLEN = 80
 
      ** Delay job by 30 seconds
 
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    DLYJOB
     C                   PARM                    CMDLEN
 
      ** If call ends in error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'QCMDEXC'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/ SRPROC'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Retrieve sequence number from time table file
 
     C                   EXSR      SRTMPF
 
      ** To Update Projected Nostro Accounts Control file
     C                   ELSE
     C                   EVAL      LSEQNO = *ZEROS
 
     C                   EXSR      SRUPDLM
     C                   ENDIF
 
      ** Read in Data Area GLNOSTCTL
     C                   IN        GLNOSTCTL
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      **Calls:*SRRCFA,AOBANKR0*****************************************                      BG12134
      * Calls: AOBANKR0                                               *                      BG12134
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** File opening section
 
     C                   IF        Not %Open(AF710LF)
     C                   OPEN      AF710LF
     C                   ENDIF
      *
     C                   IF        Not %Open(GLNOSTPD)
     C                   OPEN      GLNOSTPD
     C                   ENDIF
 
      ** Define Data Areas GLNOSTCTL & LDA
 
     C     *DTAARA       DEFINE                  GLNOSTCTL
 
     C     *DTAARA       DEFINE                  LDA
 
      ***Registers*GL0446AU*via*RCF************************************                      BG12134
 
     C**********         EXSR      SRRCFA                                                    BG12134
 
      ** Initialization of fields DBASE,DBFILE,DBKEY
 
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
 
      ** To retrieve the bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY   =  @OPTN
     C                   EVAL      DBASE   =  005
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SRTMPF*-*Subroutine*To*Read*The*AF6PF*File*********************                      BG12067
      * SRTMPF - Subroutine To Read The AF610LF file                  *                      BG12067
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
     C     SRTMPF        BEGSR
 
      ***Retrive*Sequence*Number*From*AF6PF****************************                      BG12067
      ** Retrive Sequence Number From AF610LF                                                BG12067
 
     C**********         IF        Not %Open(AF6PF)                                          BG12067
     C**********         OPEN      AF6PF                                                     BG12067
     C                   IF        Not %Open(AF610LF)                                        BG12067
     C                   OPEN      AF610LF                                                   BG12067
     C                   ENDIF
 
     C**********         READ      AF6PF                                                     BG12067
     C     *HIVAL        SETGT     AF610LF                                                   BG12067
     C                   READP     AF610LF                                                   BG12067
     C                   EVAL      TSEQNO  =  AF6SEQ
 
     C**********         IF        %Open(AF6PF)                                              BG12067
     C**********         CLOSE     AF6PF                                                     BG12067
     C                   IF        %Open(AF610LF)                                            BG12067
     C                   CLOSE     AF610LF                                                   BG12067
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                      BG12134
      ***SRRCFA**-*Subroutine*to*register*GL000446AU*via*RCF.**********                      BG12134
      *****************************************************************                      BG12134
      ***Called*By:**INZSR*********************************************                      BG12134
      *****************************************************************                      BG12134
      ***Calls:*ZSFILE*************************************************                      BG12134
      *****************************************************************                      BG12134
      *****************************************************************                      BG12134
     C*****SRRCFA        BEGSR                                                               BG12134
      *****************************************************************                      BG12134
     C**********         Z-ADD     SFNUMU        PZSNUM                                      BG12134
      *****************************************************************                      BG12134
      ***Ensure*Audit*Spool*File*recorded*by*RCF***********************                      BG12134
      *****************************************************************                      BG12134
     C**********         CALL      'ZSFILE'                                                  BG12134
     C**********         PARM      *BLANKS       PSEQ                                        BG12134
     C**********         PARM      *BLANKS       PSENTY                                      BG12134
     C**********         PARM                    SFILEU                                      BG12134
     C**********         PARM                    PZSNUM                                      BG12134
     C**********         PARM      *BLANKS       PZSERR                                      BG12134
      *****************************************************************                      BG12134
      ***IF*call*ends*in*error,return*back*to*calling*program**********                      BG12134
      *****************************************************************                      BG12134
     C**********         IF        PZSERR = 'Y'                                              BG12134
     C**********         EVAL      *INU7 = *ON                                               BG12134
     C**********         EVAL      *INU8 = *ON                                               BG12134
     C**********         EVAL      *INLR = *ON                                               BG12134
     C**********         RETURN                                                              BG12134
     C**********         ENDIF                                                               BG12134
      *****************************************************************                      BG12134
     C**********         ENDSR                                                               BG12134
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDLM - Subroutine To Update Projected Nostro Accounts     *
      *            Control File                                       *
      *                                                               *
      *  Called By: Main Processing,PROJAM                            *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
 
     C     SRUPDLM       BEGSR
 
      ** Reading the Projected Nostro Accounts Control file
 
     C     1             SETLL     GLNOSTPD
     C                   READ(E)   GLNOSTPD
 
      ** Read ends in error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLNOSTPD'
     C                   MOVEL     NOLRSN        DBKEY
     C                   EVAL      DBASE   =  002
     C                   EVAL      DBPROC = 'SR/SRUPDLM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      NOLRSN = LSEQNO
 
     C                   IF        NOT %EOF(GLNOSTPD)                                       BG12067
                                                                                            BG12067
      ** Update the Projected Nostro Accounts Control file
 
     C                   UPDATE(E) GLNOSTD0
     C                   ELSE                                                               BG12067
                                                                                            BG12067
      ** Write the Projected Nostro Accounts Control file                                   BG12067
                                                                                            BG12067
     C                   WRITE(E)  GLNOSTD0                                                 BG12067
     C                   ENDIF                                                              BG12067
 
      ** Update ends in error
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLNOSTPD'
     C                   MOVEL     NOLRSN        DBKEY
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBPROC = 'SR/SRUPDLM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Commit all changes
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOST  - Subroutine To Validate Nostro Code                 *
      *                                                               *
      *  Called By: PROJAM                                            *
      *                                                               *
      *  Calls: AONOSTR0                                              *
      *****************************************************************
 
     C     SRNOST        BEGSR
 
     C                   EVAL      P@CYCD = %SUBST(AF7FUN :1:3)
     C                   EVAL      P@NONB = %SUBST(AF7FUN :4:2)
     C                   EVAL      WNSTCD = %SUBST(AF7FUN :1:5)
 
      ** Verify the Nostro Codes in the MIDAS file
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM                    P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM                    P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
 
      ** Call Ends In Error
 
     C                   IF        @RTCD <> *BLANKS
     C******LOCK         IN        LDA                                                       BG12067
     C**********         EVAL      DBFILE = 'SDNOSTPD'                                       BG12067
     C**********         EVAL      DBKEY  = WNSTCD                                           BG12067
     C**********         EVAL      DBASE  =  004                                             BG12067
     C**********         EVAL      DBPROC = 'SR/SRNOST'                                      BG12067
     C**********         OUT       LDA                                                       BG12067
     C**********         EXSR      *PSSR                                                     BG12067
     C                   GOTO      ENDSRN                                                    BG12067
     C                   ENDIF
 
     C     ENDSRN        TAG                                                                 BG12067
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CVTDATE - Subroutine To Validate And Convert Date Into       *
      *            MIDAS Day Number                                   *
      *                                                               *
      *  Called By: PROJAM                                            *
      *                                                               *
      *  Calls: ZDATE1                                                *
      *****************************************************************  --+
 
     C     CVTDATE       BEGSR
 
      ** To Convert date into Midas day number
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEIN
     C                   PARM                    DAYNOOUT
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       @ERRFLAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine To Output Audit report and End           *
      *            Program.                                           *
      *                                                               *
      *  Called By: *PSSR                                             *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Write the Output Report Header
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = *ON
 
      ** Write the DB Error Information
 
     C                   WRITE     DBERROR
     C                   ENDIF
 
      ** Write the footer
 
     C                   WRITE     FOOTAU
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDNSSHD - Subroutine To Update the Account Shadow           *
      *             Balances File                                     *
      *                                                               *
      *  Called By: PROJAM                                            *
      *                                                               *
      *  Calls: AOMEMSU0                                              *
      *****************************************************************
 
     C     UPDNSSHD      BEGSR
 
     C**********         MOVEL     A7CUST        W0CNUM                                      BG12067
     C**********         MOVEL     A7CYCD        W0CUCD                                      BG12067
     C**********         MOVEL     A7ACCD        W0ACCD                                      BG12067
     C**********         MOVEL     A7ACSN        W0ACSQ                                      BG12067
     C**********         MOVEL     A7BRCD        W0BRCA                                      BG12067
     C                   EVAL      P0CNUM = A7CUST                                           BG12067
     C                   EVAL      P0CUCD = A7CYCD                                           BG12067
     C                   EVAL      P0ACCD = A7ACCD                                           BG12067
     C                   MOVEL     A7ACSN        P0ACSQ                                      BG12067
     C                   EVAL      P0BRCA = A7BRCD                                           BG12067
     C                   EVAL      W0PSTD = VALDATE
     C                   EVAL      W0VDAT = PSTDATE
     C                   EVAL      W0AMT  = MAMT
                                                                                             BG12067
     ** Check if Account is Nostro Account or Nostro Retail Account                          BG12067
                                                                                             BG12067
     C                   CALL      'AOACCTR0'                                                BG12067
     C                   PARM      *BLANKS       @RTCD                                       BG12067
     C                   PARM      '*KEY   '     @OPTN                                       BG12067
     C                   PARM      *BLANKS       P0RETL                                      BG12067
     C                   PARM                    P0CNUM                                      BG12067
     C                   PARM                    P0CUCD                                      BG12067
     C                   PARM                    P0ACCD                                      BG12067
     C                   PARM                    P0ACSQ                                      BG12067
     C                   PARM                    P0BRCA                                      BG12067
     C     SDACNT        PARM                    DSSDY                                       BG12067
                                                                                             BG12067
      ** Call ends in error                                                                  BG12067
                                                                                             BG12067
     C                   IF        @RTCD <> *BLANKS                                          BG12067
     C     *LOCK         IN        LDA                                                       BG12067
     C                   EVAL      DBFILE = 'ACCNTAB'                                        BG12067
     C                   EVAL      DBKEY  = P0CNUM + P0CUCD + P0ACCD                         BG12067
     C                                      + P0ACSQ + P0BRCA                                BG12067
     C                   EVAL      DBASE  = 012                                              BG12067
     C                   EVAL      DBPROC = 'SR/UPDNSSHD'                                    BG12067
     C                   OUT       LDA                                                       BG12067
     C                   EXSR      *PSSR                                                     BG12067
                                                                                             BG12067
     C                   ELSE                                                                BG12067
     C                   IF        ATYP = 'R'                                                BG12067
                                                                                             BG12067
     C                   EVAL      W0RETL = ACNO                                             BG12067
 
      ** To update the account shadow balances file
 
     C                   CALL(E)   'AOMEMSU0'
     C                   PARM      *BLANKS       @RTCD
     C**********         PARM      *ZEROS        W0RETL                                      BG12067
     C                   PARM                    W0RETL                                      BG12067
     C                   PARM                    W0CNUM
     C                   PARM                    W0CUCD
     C                   PARM                    W0ACCD
     C                   PARM                    W0ACSQ
     C                   PARM                    W0BRCA
     C                   PARM                    W0PSTD
     C                   PARM                    W0VDAT
     C                   PARM                    W0AMT
     C                   PARM      *BLANKS       W0FTOV
 
      ** Call ends in error
 
     C                   IF        %ERROR OR @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'AOMEMSU0'
     C                   EVAL      DBASE  =  007
     C                   EVAL      DBPROC = 'SR/UPDNSSHD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                               BG12067
     C                   ENDIF                                                               BG12067
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDRLMVT - Subroutine To Update the Real Time Account        *
      *             Movements File                                    *
      *                                                               *
      *  Called By: PROJAM                                            *
      *                                                               *
      *  Calls: AOSVALR0,AONARRR0,AORSACW0.                           *
      *****************************************************************
 
     C     UPDRLMVT      BEGSR
 
      ** Set fields of the Data Structure RSACMT
 
     C**********         MOVEL     AF7CUSN       RSCUSN                                     BUG14597
     C                   MOVEL     AF7CCYD       RSCCYD
     C**********         MOVEL     AF7SNC        RSASNC                                     BUG14597
     C**********         MOVEL     AF7BRCA       RSBRCA                                     BUG14597
     C                   MOVEL     PSTDATE       RSPTDT
     C                   MOVEL     VALDATE       RSVUDT
     C                   MOVEL     'CB'          RSTRYP
     C                   MOVEL     A7CUST        RSCUSN                                     BUG14597
     C                   MOVEL     A7ACSN        RSASNC                                     BUG14597
     C                   MOVEL     A7BRCD        RSBRCA                                     BUG14597
 
      ** To get the system value(ConsumerBankingNarr) for the
      ** Narrative Code
 
     C**********         CALL      'AOSVALR0'                                               BUG14589
     C**********         PARM      *BLANKS       @RTCD                                      BUG14589
     C**********         PARM      SVALKK        SVALK1                                     BUG14589
     C**********         PARM                    SVAL1                                      BUG14589
     C**********         PARM      *BLANKS       SVALK2                                     BUG14589
     C**********         PARM                    SVAL2                                      BUG14589
     C**********         PARM      *BLANKS       SVALK3                                     BUG14589
     C**********         PARM                    SVAL3                                      BUG14589
     C**********         PARM      *BLANKS       SVALK4                                     BUG14589
     C**********         PARM                    SVAL4                                      BUG14589
     C**********         PARM      *BLANKS       SVALK5                                     BUG14589
     C**********         PARM                    SVAL5                                      BUG14589
     C**********         PARM      *BLANKS       SVALK6                                     BUG14589
     C**********         PARM                    SVAL6                                      BUG14589
     C**********         PARM      *BLANKS       SVALK7                                     BUG14589
     C**********         PARM                    SVAL7                                      BUG14589
     C**********         PARM      *BLANKS       SVALK8                                     BUG14589
     C**********         PARM                    SVAL8                                      BUG14589
     C**********         PARM      *BLANKS       SVALK9                                     BUG14589
     C**********         PARM                    SVAL9                                      BUG14589
     C**********         PARM      *BLANKS       SVALK0                                     BUG14589
     C**********         PARM                    SVAL10                                     BUG14589
      **********                                                                            BUG14589
      ***Call*ends in error                                                                 BUG14589
      **********                                                                            BUG14589
     C**********         IF        @RTCD <> *BLANKS                                         BUG14589
     C******LOCK         IN        LDA                                                      BUG14589
     C**********         EVAL      DBFILE = 'SDSVALPD'                                      BUG14589
     C**********         EVAL      DBKEY  =  SVALKK                                         BUG14589
     C**********         EVAL      DBASE  =  009                                            BUG14589
     C**********         EVAL      DBPROC = 'SR/UPDRLMVT'                                   BUG14589
     C**********         OUT       LDA                                                      BUG14589
     C**********         EXSR      *PSSR                                                    BUG14589
     C**********         ENDIF                                                              BUG14589
 
     C**********         MOVEL     SVAL11        RSNRTC                                     BUG14589
     C                   MOVEL     SVALCB        RSNRTC                                     BUG14589
     C                   MOVEL     SVALCB        SVAL11                                     BUG14589
 
      ** To get the Narrative Description from the MIDAS file
 
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    SVAL11
     C     SDNARR        PARM      *BLANKS       DSFDY
 
      ** Call ends in error
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNARRPD'
     C                   EVAL      DBKEY  =  SVAL11
     C                   EVAL      DBASE  =  010
     C                   EVAL      DBPROC = 'SR/UPDRLMVT'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     ALDON         RSNRTD
     C                   MOVEL     '999998'      RSTNMR
     C                   MOVEL     AF7MVAM       RSMVAM
     C                   MOVEL     AF7DORC       RSDORC
     C                   MOVEL     A7ACCD        RSACDE
     C                   MOVEL     AF7FUN        RSFUND
 
      ** To update the real time account movements file
 
     C                   CALL      'AORSACW0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    MAMT
     C                   PARM      RSACMT        DSSDY
 
      ** Call ends in error
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'AORSACW0'
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBPROC = 'SR/UPDRLMVT'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROJAM - Subroutine To Update the Nostro Projections File    *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls: AOPRONU0                                              *
      *****************************************************************
 
     C     PROJAM        BEGSR
 
     C                   EXSR      SRNOST
     C                   IF        @RTCD <> *BLANKS                                          BG12067
     C                   GOTO      NOUPD                                                     BG12067
     C                   ENDIF                                                               BG12067
 
      ** Convert Value date(YYMMDD) to Midas Run Number
 
     C                   MOVE      AF7VUDT       WDATEA
     C                   EVAL      WDATEA = %SUBST(WDATEA:3:4)
     C                             +%SUBST(WDATEA:1:2)
     C                   MOVE      WDATEA        DATEIN
     C                   MOVE      'M'           BJDFIN
 
      ** Convert The Date to Midas Day Number
 
     C                   EXSR      CVTDATE
 
     C                   MOVE      DAYNOOUT      VALDATE
 
      ** Convert Posting date(YYMMDD) to Midas Run Number
 
     C                   MOVE      AF7PTDT       WDATEA
     C                   EVAL      WDATEA = %SUBST(WDATEA:3:4)
     C                             + %SUBST(WDATEA:1:2)
     C                   MOVE      WDATEA        DATEIN
     C                   MOVE      'M'           BJDFIN
 
      ** Convert The Date to Midas Day Number
 
     C                   EXSR      CVTDATE
     C                   MOVE      DAYNOOUT      PSTDATE
 
      ** IF DORC is 1 (Credit)
 
     C                   IF        AF7DORC = 1
     C                   EVAL      MAMT = (AF7MVAM * -1)
     C                   ELSE
 
      ** IF DORC is 0 (Debit)
     C                   IF        AF7DORC = 0
     C                   EVAL      MAMT = AF7MVAM
     C                   ELSE
 
      ** Error
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AF710LF'
     C                   EVAL      DBKEY = 'AF7DORC'
     C                   EVAL      DBASE  = 011
     C                   EVAL      DBPROC = 'SR/PROJAM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C
     C                   ENDIF
     C                   ENDIF
 
      ** To update the on-line Nostro balances file
 
     C                   CALL(E)   'AOPRONU0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    WNSTCD
     C                   PARM                    VALDATE
     C                   PARM                    MAMT
 
      ** Call ends in error
 
     C                   IF        %ERROR OR @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'AOPRONU0'
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBPROC = 'SR/PROJAM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      UPDNSSHD
 
     C                   EXSR      UPDRLMVT
 
      ** Delete Record from The AF710LF
 
     C**********         DELETE    AF710LF                                                 BUG14826A
 
     C                   IF        LSEQNO > NOLRSN
 
      ** Update Projected Nostro Accounts Control file
 
     C                   EXSR      SRUPDLM
     C                   ENDIF
 
      ** Commit all the changes
     C                   COMMIT
 
     C     NOUPD         TAG                                                                 BG12067
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPGM
     C                   EVAL      DBMOD = PSProcMOD
     C                   OUT       LDA
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
      ** Rollback all changes
 
     C                   ROLBK
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
      ** Output Audit report and End Program
 
     C                   EXSR      SRAUDT
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**
DLYJOB DLY(30)

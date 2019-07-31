     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIBRW - Midas FF Market Prices Function Code             *
      *              Details Browse                                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of FUNCTION DESCRIPTION        *
      *             details for selection , the other picks off the   *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG10450           Date 08Feb06               *
      *                 BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG10450 - Nondisplay Risk Factor if OTC                     *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFMPRIBDF CF   E             WORKSTN
     F                                     SFILE(FFMPRIS1:@@RRN)
     F                                     SFILE(FFMPRIS3:@@RRN)
 
      ** Market Prices Details File - by Transaction number
     FPRICS     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICSDF:PRICTRNN)
     F                                     USROPN
 
      ** Market Prices Details File - by Front Office Id.
     FPRICS2    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICSDF:PRICFOID)
     F                                     USROPN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      ** Midas FF Selected Instrument Type Details
     FINTYP2    IF   E           K DISK
     F                                      RENAME(INTYPDF:INTYP2DF)
 
      ** Midas FF Instrument Types
     FINTYP     IF   E           K DISK
 
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
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of the
      ** arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **------------------------------------------------------------------
 
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
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** Months Short Names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** Market Prices Transaction Parameter Key
     D PRTRNN          DS            27
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
      ** Selected Market Prices Transaction Key
     D @TRSEL          DS            27
     D  @TRISTT                1      5
     D  @TRMRKT                1      2
     D  @TRISTC                3      5
     D  @TRMTHN                6      8
     D  @TRYRNO                9     10
     D  @TRPCAL               11     11
     D  @TRSTRP               12     27
 
      ** Key to LF/INTYP
      ** Also, re-defines Instr. Type  into Mkt Centre + Instr. Code
     D ISTTK           DS             5
     D  KISTT                  1      5
     D  KMRKT                  1      2
     D  KISTC                  3      5
 
      ** Selected Market Prices Transaction Key
     D DDISTT          DS
     D  @SPMRKT                1      2
     D  @SPISTC                3      5
 
      ** Position To Intrument Type
     D DPISTT          DS
     D  @DPMRKT                1      2
     D  @DPISTC                3      5
 
      **
     D FTRFK           DS             5
     D  MRKT                   1      2
     D  FTRF                   3      5
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Price (Screen Format)
     D FFSPRC          S             16A
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      ** Strike Price in Numeric Format Parameter
     D @PSTRP          S             15  8
 
      ** Key list definition to Market Prices Detail File
     D @@ISTT          S                   LIKE(ISTT)
     D @@MTHN          S                   LIKE(MTHN)
     D @@YRNO          S                   LIKE(YRNO)
     D @@PCAL          S                   LIKE(PCAL)
     D @@STRP          S                   LIKE(STRP)
 
      ** Save Fields for Position To
     D SVISTT          S                   LIKE(DPISTT)
     D SVYRNO          S                   LIKE(DPYRNO)
     D SVMTHN          S                   LIKE(DPMTHN)
     D SVPCAL          S                   LIKE(DPPCAL)
     D SVSTRP          S                   LIKE(DPSTRP)
     D SVFRNT          S             20A
 
      ** Indicator Flags
     D wFileOpenF      S              1A   INZ('N')
     D POTCFlag        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** Instrument Types
      *
     IINTYPDF
     I              BCPT                        BCPTI
     I              CCPT                        CCPTI
     I              CTAM                        FFCTAM
     I              CNTT                        FFCNTT
      *
      ** Selected Instrument Type details
      *
     IINTYP2DF
     I              RECI                        RECI2
     I              ISTT                        ISTT2
     I              ISTI                        ISTI2
     I              ISPT                        ISPT2
     I              ISCY                        ISCY2
     I              QOTC                        QOTC2
     I              TKDM                        TKDM2
     I              MNPF                        MNPF2
     I              TKVL                        TKVL2
     I              OTHC                        OTHC2
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
      *
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = PRTRNN
     C                   EVAL      ActionCode = DDACTN
 
      **------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **------------------------------------------------------------------
 
 
      ** Initialisation
 
     C                   IF        PRISTC = *BLANK and
     C                             PRMTHN = *BLANK and
     C                             PRYRNO = *BLANK and
     C                             PRPCAL = *BLANK and
     C                             PRSTRP = *BLANK
 
     C                   MOVE      *BLANK        DPISTT
     C                   MOVE      *BLANK        DPYRNO
     C                   MOVE      *BLANK        DPMTHN
     C                   MOVE      *BLANK        DPPCAL
     C                   MOVE      *BLANK        DPSTRP
 
     C                   MOVE      *BLANK        SVISTT
     C                   MOVE      *BLANK        SVYRNO
     C                   MOVE      *BLANK        SVMTHN
     C                   MOVE      *BLANK        SVPCAL
     C                   MOVE      *BLANK        SVSTRP
                                                                                            BUG10450
     C                   IF        POTCFlag = 'Y'                                           BUG10450
     C                   EVAL      *IN08 = *ON                                              BUG10450
     C                   ELSE                                                               BUG10450
     C                   EVAL      *IN08 = *OFF                                             BUG10450
     C                   ENDIF                                                              BUG10450
 
     C                   ENDIF
 
      ** Rebuild Subfile Starting at Position to
 
     C     Repostn       TAG
 
     C                   EXSR      INIT
 
      ** BUILD Sub-file
     C                   IF        @BDSFL = 'Y'
 
      ** If First time in or subfile by Midas transaction number was previously
      ** being run, then build subfile keyed on Midas transaction number.
      ** Stay in loop while F11 toggle key is used.
     C                   IF        WTrnK <> 'F' and
     C                             WTrnK <> 'S'
 
     C                   MOVE      'B'           WTrnK
 
     C                   ENDIF
 
     C                   DOU       *INKK = '0'
 
      ** On F11, initialise position/select fields
 
     C                   IF        *INKK = '1'
 
     C                   EVAL      PRTRNN = *BLANK
     C                   EVAL      DDISTT = *BLANK
     C                   EVAL      DDMTHN = *BLANK
     C                   EVAL      DDYRNO = *BLANK
     C                   EVAL      DDPCAL = *BLANK
     C                   EVAL      DDSTRP = *BLANK
     C                   EVAL      DDNEWP = *BLANK
     C                   EVAL      DDSTRPN= *ZEROS
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C     WTrnK         CASEQ     'B'           BLDSFL
     C     WTrnK         CASEQ     'F'           BLDSFL2
     C                   ENDCS
     C                   ENDDO
 
     C                   ENDIF
 
      ** If Position To field is not equal the saved Position To values, rebuild subfile.
 
     C                   IF        @DPISTC <> PRISTC   or
     C                             DPYRNO  <> PRYRNO   or
     C                             DPMTHN  <> PRMTHN   or
     C                             DPPCAL  <> PRPCAL   or
     C                             DPSTRP  <> PRSTRP
 
      ** Move position to values to reference pointer parameters
 
     C                   MOVE      DPISTT        PRISTT
     C                   MOVE      DPYRNO        PRYRNO
     C                   MOVE      DPMTHN        PRMTHN
     C                   MOVE      DPPCAL        PRPCAL
     C                   MOVE      DPSTRP        PRSTRP
 
      ** Save current Position To values
 
     C                   EVAL      SVISTT  =  DPISTT
     C                   EVAL      SVYRNO  =  DPYRNO
     C                   EVAL      SVMTHN  =  DPMTHN
     C                   EVAL      SVPCAL  =  DPPCAL
     C                   EVAL      SVSTRP  =  DPSTRP
 
 
     C                   GOTO      Repostn
 
     C                   ENDIF
 
      ** READ Subfile Record
     C                   IF        @RDSFL = 'Y'  and
     C                             WTrnK <> *BLANK
 
     C                   EXSR      RDSFLR
 
     C                   ENDIF
 
     C                   IF        wFileOpenF = 'Y'
     C                   CLOSE     PRICS
     C                   CLOSE     PRICS2
     C                   EVAL      wFileOpenF = 'N'
     C                   ENDIF
 
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Clear outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @TRSEL = *BLANK
     C                   EVAL      @INKC  = '0'
 
     C                   IF        wFileOpenF = 'N'
     C                   OPEN      PRICS
     C                   OPEN      PRICS2
     C                   EVAL      wFileOpenF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters :
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Action Code
     C                   PARM                    DDACTN            1
 
      ** Market Prices Transaction Reference Pointer
     C                   PARM                    PRTRNN
 
      ** Build Subfile
     C                   PARM                    @BDSFL            1
 
      ** Read Subfile Record
     C                   PARM                    @RDSFL            1
 
      ** Strike price numeric format
     C                   PARM                    @PSTRP
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters:
      ** Error Message
      ** Option Selected
      ** Transaction Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL
 
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'FFMPRIBRW'
 
      ** Move workstation ID to screen field.
     C                   EVAL      DDWID = PsJobName
     C                   EVAL      DDUSER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE =  901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Define key list for  @@TRNN
     C     @@TRNN        KLIST
     C                   KFLD                    @@ISTT
     C                   KFLD                    @@YRNO
     C                   KFLD                    @@MTHN
     C                   KFLD                    @@PCAL
     C                   KFLD                    @@STRP
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Validate Transaction Reference
     C                   EXSR      VALTran
 
      ** Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
     C                   EVAL      *IN97 = *ON
     C                   WRITE     FFMPRIS0
     C                   EVAL      *IN97 = *OFF
 
      ** Set file pointer on key displayed on screen.
     C     @@TRNN        SETLL     PRICS                              90
 
      ** Read a Valid Transaction
     C                   EXSR      RDTran
 
     C                   IF        *IN96 = *ON
 
      ** Try to read previously to 'Position To' the last record.
     C                   IF        WTrnK = 'B'
 
     C     @@TRNN        SETLL     PRICS                              90
     C                   READP     PRICTRNN                               96
      ** But if still on, then set @@EOF to 'Y'
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ELSE
     C                   EVAL      @@EOF = ' '
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up message 'no data to display'
     C                   EVAL      *IN80 = *OFF
 
     C                   IF        @@EOF = 'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
     C                   EVAL      *IN98 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
     C                   DOW       *IN98 = *ON
 
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             @@CNT             3 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT < 14
 
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Format transaction fields for output
     C                   EXSR      FMTtran
 
      ** Write the transaction to the subfile.
 
      ** If action code or Transaction number selected is invalid
      ** the subfile postions on the error record and rebuilds
     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C                   IF        *IN99 <> '1'
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FFMPRIS1
 
      ** Read a valid Transaction
     C                   EXSR      RDTran
     C                   ENDDO
 
      ** Set up footer toggle text and write the footer
     C                   WRITE     FFMPRIF1
 
      ** Write the message subfile
     C                   WRITE     FFMPRIM0
 
      ** If there is no data to display, set on SFLCLR condition and
      ** Write the subfile control record
     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     FFMPRIS0
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1
 
      ** Write to the subfile with non-display set on
     C                   EVAL      *IN93 = *ON
     C                   WRITE     FFMPRIS1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     FFMPRIS0
     C                   ELSE
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
     C                   WRITE     FFMPRIS0
     C                   ENDIF
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
     C                   READ      FFMPRIS0                               99
 
      ** Clear any messages before processing user input
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
      ** If F3, bypass further processing.
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F12,  bypass further processing.
     C                   IF        *INKL = *ON
     C                   EVAL      @INKL = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set indicator ans flag for Midas Front Office I.D. browse key used
     C                   IF        *INKK = *ON
     C                   MOVE      'F'           WTrnK             1
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************
 
     C     BLDSFL2       BEGSR
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Validate Transaction Reference
     C                   EXSR      VALTran
 
      ** Get Front Office Transaction Reference
     C     @@TRNN        CHAIN     PRICS                              89
 
     C                   MOVE      FRNT          @@FOID           20
 
     C                   IF        *IN89  = *ON
     C                   EVAL      @@FOID = *BLANKS
     C                   ENDIF
 
      ** Initialise subfile relative record number.
     C                   EVAL      @@RRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
     C                   EVAL      *IN97 = *ON
     C                   WRITE     FFMPRIS2
     C                   EVAL      *IN97 = *OFF
 
      ** Set file pointer on key displayed on screen.
     C     @@FOID        SETLL     PRICFOID
 
      ** Read a Valid Trade
 
     C                   EXSR      RDTran
 
      ** Set up message 'no data to display'
     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
     C                   EVAL      *IN98 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
     C                   DOW       *IN98 = *ON
 
      ** Initialise count of records written to subfile page.
     C                   EVAL      @@CNT = 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT <  14
 
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Format custom fields for output
     C                   EXSR      FMTtran
 
      ** Write the customer to the subfile.
 
      ** If action code or Transaction number selected is invalid,
      ** the subfile postions on the error record and rebuilds
     C                   EVAL      *IN92 = *OFF
     C                   IF        @@RRN <> 1
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C                   IF        *IN99 <> '1'
     C                   EVAL      DDOPTN = *BLANK
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     FFMPRIS3
 
      ** Read a valid Transaction
     C                   EXSR      RDTran
     C                   ENDDO
 
      ** Set up footer toggle text and write the footer
     C                   WRITE     FFMPRIF1
 
      ** Write the message subfile
     C                   WRITE     FFMPRIM0
 
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record
     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     FFMPRIS2
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1
 
      ** Write to the subfile with non-display set on
     C                   EVAL      *IN93 = *ON
     C                   WRITE     FFMPRIS3
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     FFMPRIS2
     C                   ELSE
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
     C                   WRITE     FFMPRIS2
     C                   ENDIF
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
     C                   READ      FFMPRIS2                               99
 
      ** Clear any messages before processing user input
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
      ** If F3, bypass further processing.
     C                   IF        *INKC  = *ON
     C                   EVAL      @INKC  = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F9, bypass further processing.
     C                   IF        *INKI  = *ON
     C                   EVAL      @OPSEL = 'I'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set indicator and flag for Midas (back) office Transaction number key
     C                   IF        *INKK  = *ON
     C                   EVAL      WTrnK  = 'B'
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
 
     C                   DOU       *IN99  = *ON or
     C                             DDOPTN <> *BLANK
 
     C                   IF        WTrnK  = 'B'
     C                   READC     FFMPRIS1                               99
     C                   ENDIF
     C                   IF        WTrnK  = 'F'
     C                   READC     FFMPRIS3                               99
     C                   ENDIF
 
     C                   ENDDO
 
      ** Return the selected transaction reference and option
 
     C                   IF        *IN99 <> '1' and
     C                             DDOPTN <> *BLANK
 
     C                   IF        DDOPTN = 'A' or
     C                             DDOPTN = 'D'
     C                   EVAL      @OPSEL = DDOPTN
     C                   ELSE
     C                   EVAL      @OPSEL = 'E'
     C                   ENDIF
 
      ** Instrument Type
 
     C                   MOVE      DDISTT        PRISTT
 
      ** Month Name
 
     C                   MOVE      DDMTHN        PRMTHN
 
      ** Year No.
 
     C                   MOVE      DDYRNO        PRYRNO
 
      ** Put/Call Indicator
 
     C                   MOVE      DDPCAL        PRPCAL
 
      ** Strike Price
 
     C                   MOVE      DDSTRP        PRSTRP
     C                   MOVE      DDSTRPN       @PSTRP
 
      ** Return selected record in PRTRNN
 
     C                   EVAL      @TRSEL =   PRTRNN
 
      ** Return selected record in position to fields
 
     C                   MOVE      PRISTT        DPISTT
     C                   MOVE      PRYRNO        DPYRNO
     C                   MOVE      PRMTHN        DPMTHN
     C                   MOVE      PRPCAL        DPPCAL
     C                   MOVE      PRSTRP        DPSTRP
 
     C                   ENDIF
 
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTtran - FORMAT Market Price TRANSACTION FOR OUTPUT
      ******************************************************************
     C     FMTtran       BEGSR
 
      ** Record ID
     C                   IF        RECI   = '*'
     C                   EVAL      *IN95  = *ON
     C                   EVAL      DDRECI = 'D'
     C                   ELSE
     C                   EVAL      DDRECI = *blank
     C                   EVAL      *IN95  = *OFF
     C                   Endif
 
      ** Instrument Type
     C                   EVAL      DDISTT = ISTT
 
     C     ISTT          CHAIN     INTYP                              50
 
      ** Database error If NOT Found
 
     C                   IF        not %found  OR RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     KISTT         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access underlying instrument if appropriate
 
     C*****@SPMRKT       IFNE      *BLANK                                                   BUG10387
     C     POTCFlag      IFNE      'Y'                                                      BUG10387
     C     ISPT          ANDGT     3
     C     ISPT          ANDNE     7
     C                   EVAL      MRKT = @SPMRKT
     C     FTRFK         CHAIN     INTYP2                             50
 
     C                   IF        not %found  OR RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     FTRFK         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     TKDM          TKDM2
     C                   Z-ADD     MNPF          MNPF2
 
     C                   ENDIF
 
     C                   MOVE      *BLANKS       DDYRNO
      ** Month
     C                   IF        POTCFlag <> 'Y'
 
     C                   MOVE      ZMNM(MTHN)    DDMTHN
 
      ** Year Number
 
     C                   IF        YRNO > 0    or
     C                             YRNO = 0
     C                   MOVE      YRNO          DDYRNO
     C                   ENDIF
     C                   ENDIF
 
      ** Put/Call
 
     C                   EVAL      DDPCAL = PCAL
 
      ** Strike Price
 
      ** 'Futures'
     C     ISPT          IFLE      3
     C     ISPT          OREQ      7
     C                   MOVE      *BLANK        DDSTRP
 
      ** 'Options'
     C                   ELSE
     C                   Z-ADD     TKDM2         FFTKDM            3 0
     C                   Z-ADD     MNPF2         FFMNPF           15 8
     C                   Z-ADD     STRP          FFPRIC           15 8
 
      ** Format price
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** -----------------------------------------
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
      ** Screen version of price (16A)
     C                   PARM                    ReturnCode
     C                   PARM                    FFSPRC
      ** -------------------------------------
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
      ** Move to screen
 
     C                   EVAL      DDSTRP  =  FFSPRC
 
     C                   ENDIF
 
      ** Strike Price to Hidden Strike Price in Num format
 
     C                   MOVE      STRP          DDSTRPN
 
      ** New Price
 
     C                   Z-ADD     TKDM          FFTKDM            3 0
     C                   Z-ADD     MNPF          FFMNPF           15 8
     C                   Z-ADD     NEWP          FFPRIC           15 8
 
      ** Format price
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** -----------------------------------------
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
      ** Screen version of price (16A)
     C                   PARM                    ReturnCode
     C                   PARM                    FFSPRC
      ** -------------------------------------
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
      ** Move to screen
 
     C                   MOVE      FFSPRC        DDNEWP
 
      ** Risk Factor
 
     C                   Z-ADD     7             ZADEC             1 0
     C                   MOVE      *BLANK        ZFIELD           16
     C                   MOVE      RSKF          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDRSKF
 
 
      ** Front Office ID
 
     C                   EVAL      DDFOID = FRNT
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDTran - READ A TRANSACTION
      *****************************************************************
     C     RDTran        BEGSR
 
      ** Reset End of File and skip record indicator
 
     C                   MOVE      *BLANK        @@EOF             1
 
      ** Read the file initially - if @@EOF is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
     C                   DOU       @@EOF = 'Y' or
     C                             @@ERR = *ZERO and
     C                             CHTP   <> 'D'
 
      ** Read the file
 
      ** Position according to Transaction number
     C                   IF        WTrnK = 'B'
     C                   READ      PRICTRNN                               96
     C                   ENDIF
 
      ** Position according to Front Office Id
     C                   IF        WTrnk = 'F'
     C                   READ      PRICFOID                               96
     C                   ENDIF
 
      ** End of File
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
 
      ** Return Error Message
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTran - VALIDATE Market Price TRANSACTION REFERENCE POINTER
      *****************************************************************
     C     VALTran       BEGSR
 
     C                   IF        PRTRNN = *BLANKS
 
      ** Set the key list @@TRNN to *loval
 
     C                   MOVE      *BLANKS       @@ISTT
     C                   MOVE      *ZEROS        @@YRNO
     C                   MOVE      *ZEROS        @@MTHN
     C                   MOVE      *BLANKS       @@PCAL
     C                   MOVE      *ZEROS        @@STRP
 
     C                   ELSE
 
      ** Populate the key list with the parameter PRTRNN
 
     C                   MOVE      PRISTT        @@ISTT
 
      ** Translate Month Name to Month Number
 
     C                   EXSR      Submonth1
 
      ** Year Number
 
     C                   MOVE      PRYRNO        @@YRNO
 
      ** Put/Call Indicator
 
     C                   MOVE      PRPCAL        @@PCAL
 
      ** Move Numeric Version of Strike Price
 
     C                   MOVE      @PSTRP        @@STRP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SubMonth1 - Substitute Month Value to Numeric format
      *****************************************************************
     C     SUBMONTH1     BEGSR
 
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   MOVE      01            @@MTHN
     C                   WHEN      PRMTHN = 'FEB'
     C                   MOVE      02            @@MTHN
     C                   WHEN      PRMTHN = 'MAR'
     C                   MOVE      03            @@MTHN
     C                   WHEN      PRMTHN = 'APR'
     C                   MOVE      04            @@MTHN
     C                   WHEN      PRMTHN = 'MAY'
     C                   MOVE      05            @@MTHN
     C                   WHEN      PRMTHN = 'JUN'
     C                   MOVE      06            @@MTHN
     C                   WHEN      PRMTHN = 'JUL'
     C                   MOVE      07            @@MTHN
     C                   WHEN      PRMTHN = 'AUG'
     C                   MOVE      08            @@MTHN
     C                   WHEN      PRMTHN = 'SEP'
     C                   MOVE      09            @@MTHN
     C                   WHEN      PRMTHN = 'OCT'
     C                   MOVE      10            @@MTHN
     C                   WHEN      PRMTHN = 'NOV'
     C                   MOVE      11            @@MTHN
     C                   WHEN      PRMTHN = 'DEC'
     C                   MOVE      12            @@MTHN
     C                   OTHER
     C                   MOVE      0             @@MTHN
     C                   ENDSL
 
     C                   ENDSR
      ************************************************************************
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
(c) Finastra International Limited 2006
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC

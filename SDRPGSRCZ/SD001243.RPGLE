     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Risk Weighted Assets Code Selection Program')
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD001243  - Risk Weighted Assets Code Selection Program      *
      *                                                               *
      *  Function:  This program records valid Risk Weighted          *
      *             Assets Sets.                                      *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA03             Date 14Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL018  *CREATE    Date 17SEP02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    95         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      *
      **  Risk Weighted Asset Codes by SET
      *
     FSDRWACL2  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Risk Weighted Assets Sets Maintenance Display
      *
     FSD001243DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD1243S1:DDSFRN)
     F                                     INFDS(INFDS#)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, short data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank Details
 
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U)
      ** EXTERNAL DS FOR USER DETAILS
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Array For ZEDIT And ZALIGN
     D/COPY ZSRSRC,ZALIGNZ1LE
 
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
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
      *
      **  Reading Records
      *
     C                   EXSR      SETSCR
     C                   ENDDO
      *
      *********************************************************************
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
     C
     C     *ENTRY        PLIST
     C                   PARM                    P#RTCD            1
     C                   PARM                    P#CODE            2
     C                   PARM                    P#SETN            1
      *
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  Check System Date Format, DDMMYY (*IN95 off)
      **                            MMDDYY (*IN95 on).
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        95
     C                   ENDIF
      *
      **  Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   ENDIF
     C
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      *
      **  Set Display Variables
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDPGMQ = PSProcName
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Set SFLMSG Indicator
      *
     C                   MOVE      *ON           *IN91
      *
     C     K#Set1        KLIST
     C                   KFLD                    DDSETN
     C                   KFLD                    DDCODE
      *
     C                   ENDSR
      *
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
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  '(file)'
     C                   EVAL      DBKEY  =  '(key)'
     C                   EVAL      DBPGM  =  PSProcName
     C                   EVAL      DBASE  =  999
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
     C
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SETSCR - SET SCREEN                                           *
      *****************************************************************
      *
     C     SETSCR        BEGSR
     C
     C                   MOVE      'Y'           V#CLRM            1
     C                   MOVE      'Y'           V#BLD             1
     C
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C
     C     V#BLD         IFEQ      'Y'
     C                   EVAL      DDCODE = *loval
     C                   EVAL      DDSETN = *loval
     C                   EXSR      BLDSFL
     C     V#SFR3        IFEQ      0
     C                   EXSR      BLDSFL
     C                   ENDIF
     C                   ENDIF
     C
     C                   MOVE      *BLANK        V#BLD
     C                   EVAL      *IN80 = *off
     C                   WRITE     SD1243M0                                     MESSAGE CTL
      *
      **  Show message subfile
      *
     C     V#SFR3        IFNE      0
      *
      **  Any selection criteria?
      *
     C                   IF        DQCODE <> *BLANK OR
     C                             DQSETN <> *BLANK
     C                   EVAL      DDCODE = DQCODE
     C                   EVAL      DDSETN = DQSETN
     C                   EXSR      BLDSFL
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        V#SFR3 > 0
     C                   WRITE     SD1243F1
     C                   EXFMT     SD1243S0
     C
     C                   ELSE
      *
      **  No Record Screen
      *
     C                   MOVE      *ON           *IN80                          TEXT ON BOTTOM SCR
     C                   EVAL      V#BLD = 'Y'
     C                   WRITE     SD1243F1
     C                   EXFMT     SD1243N1
     C                   ENDIF
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Pressed F3 or F12 Key
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  Check Subfile Option
      *
     C                   MOVE      ' '           VALSFLOK          1
     C                   EXSR      VALSFL
      *
      **  Select an event
      *
     C                   IF        VALSFLOK = *BLANK
     C                   MOVE      DDCODE        P#CODE
     C                   MOVE      DDSETN        P#SETN
     C                   MOVE      *ON           *INKC                          F3 Key To Exit
     C                   ENDIF
     C
     C                   ENDDO
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE                                        *
      *****************************************************************
      *
     C     BLDSFL        BEGSR
      *
      **  Subfile Clear
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     SD1243S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     DDSFRN        V#LARC            4 0
     C                   Z-ADD     0             DDSFRN
      *
      **  Reading Cycle
      *
     C                   MOVE      *OFF          *IN25
     C     K#Set1        SETLL     SDRWACL2
     C                   MOVE      ' '           V#RDB3            1
     C
     C     *IN25         DOUEQ     *ON
     C                   READ      SDRWACL2                               25
     C
     C                   IF        *IN25 = *OFF   AND
     C                             RWRECI = *BLANK                              LIVE REC.
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN01
      *
      **  If *IN01 *ON (record is valid) record is written to SFL
      *
     C     *IN01         IFEQ      *ON
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      RWCODE        DDCODE
     C                   MOVE      RWSETN        DDSETN
      *
      **  ZEDIT RWRWAP
      **                 100.00  -->  '100.00'
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      RWRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC             1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDRWAP
     C
     C                   MOVEL(P)  RWCDESC       DDDESC
     C
     C                   ADD       1             DDSFRN
     C                   WRITE     SD1243S1
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        V#SFR3            3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
      **  Stay On The Same Record?
      *
     C                   IF        V#GO2R = 'Y' and
     C                             V#LARC <= V#SFR3
     C                   Z-ADD     V#LARC        DDSFRN
     C                   MOVE      *BLANK        V#GO2R            1
     C                   ENDIF
     C
     C                   MOVE      *ON           *IN62
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * VALSF - VALIDATE SUBFILE OPTIONS                              *
      *****************************************************************
      *
     C     VALSFL        BEGSR
      *
      **  Set of indicators and variables
      *
     C                   MOVE      *OFF          *IN70
     C                   MOVE      'OLD'         V#MODE            3
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *OFF          *IN28
      *
      **  Subfile Read Cycle
      *
     C                   DOU       *IN28 = *ON OR
     C                             V#RCS1 = 'Y'
     C                   READC     SD1243S1                               28
     C
     C                   IF        *IN28 = *OFF
     C
     C                   IF        DDOPT  = *BLANK
     C                   UPDATE    SD1243S1
     C                   ELSE
      *
      **  Any Action code
      *
     C                   MOVE      'Y'           V#RCS1
      *
      **  Save Action code to variable
      *
     C                   MOVE      DDOPT         V#ACT1            1
      *
      **  Validate option
      *
     C                   IF        DDOPT <> '1'
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN92                          PC AND RI
     C                   ENDIF
     C
     C                   MOVE      *OFF          *IN92                          PC AND RI
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
     C                   IF        V#RCS1 = 'N'
     C                   MOVE      'N'           VALSFLOK
     C                   ENDIF
      *
      **  If Error Build SFL
      *
     C     VALSFLOK      IFEQ      'N'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      ' '           DDOPT
     C                   ENDIF
      *
     C     V#RCS1        IFEQ      'Y'
     C                   UPDATE    SD1243S1
     C                   ENDIF
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSNDMSG - Send Message To The Program Message Queue          *
      * --------                                                      *
      * Called by:                                                    *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     SRSENDMSG     BEGSR
     C
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   ENDIF
     C
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM      *BLANK        ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCLRM - CLEAR MESSAGE SUBFILE                                *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
     C
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSPROCName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      /EJECT
      *

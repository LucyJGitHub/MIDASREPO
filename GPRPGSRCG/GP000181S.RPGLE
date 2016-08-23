     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP SD Select country codes')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GP000181S - Midas SD Select country codes                    *
      *                                                               *
      *  Function:  This sub-file program allows the user to select   *
      *             from a list of country codes                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG12458 *CREATE    Date 07Nov06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG12458 - COB component DLC0607 00001 failed producing a     *
      *            database error in DL0400AU report                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FGP000181S#CF   E             WORKSTN SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      ** DSP: Select Country Codes      Select record
 
     FGPCTRYL1  IF   E           K DISK    INFDS(INFDS1)
      **RTV: Country Codes             Retrieval index
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure.
     D JBDTTM          DS
      ** Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure.
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure.
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D A@CPY           DS
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
      ** Parameter declarations.
     D P1PARM          DS
      ** FLD: Country Codes
      ** B:MAP Country Code
     D  P1CNCD                 1      2
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     C     *Entry        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1CNCD        PARM      P1CNCD        WP0001            2            Country Code
 
      ** Main Routine
      ** Initialise
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL                                       DO
 
      ** Initialise & load subfile page.
 
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
 
      ** Display screen until reload requested:
 
     C     W0RSF         DOWEQ     'N'                                          DOW
 
      ** Display screen.
 
     C                   EXSR      CAEXFM
 
      **  Process response:
      ** Cancel & exit program.
 
     C   03              CAS                     ZXEXPG
 
      ** HOME: Request subfile reload.
 
     C   05              CAS                     FBRQRL
 
      ** Display next SFL page.
 
     C   27              CAS                     BBLDSF
 
      ** Process screen input.
 
     C                   CAS                     DAPR##
     C                   END
 
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     C     BAIZSF        BEGSR
 
      ** Initialise & Load subfile page.
      ** Clear subfile.
 
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
 
      ** Reset no of records in subfile.
 
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
 
      ** Position DBF file:
 
     C     KPOS          KLIST
     C                   KFLD                    A4CNCD                         Country Code
 
      ** Setup key.
 
     C                   MOVEL     #2CNCD        A4CNCD                         Country Code
     C     KPOS          SETLL     GPCTRYD0
     C                   READ      GPCTRYD0                             8782    *82=EOF
 
      ** Save previous selector values.
 
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2ISOC        WZISOC
     C                   MOVEL     #2ISOC        WZISOC                         ISO Country cod
     C     *LIKE         DEFINE    #2CNCD        WZCNCD
     C                   MOVEL     #2CNCD        WZCNCD                         Country Code
     C     *LIKE         DEFINE    #2RGCD        WZRGCD
     C                   MOVEL     #2RGCD        WZRGCD                         Region Code
     C     *LIKE         DEFINE    #2CNNM        WZCNNM
     C                   MOVEL     #2CNNM        WZCNNM                         Country Name
     C     *LIKE         DEFINE    #2BBAN        WZBBAN
     C                   MOVEL     #2BBAN        WZBBAN                         BBAN total lgth
     C     *LIKE         DEFINE    #2BBRL        WZBBRL
     C                   MOVEL     #2BBRL        WZBBRL                         BBAN bank lgth
 
      ** Translate search mask for text field.
 
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2CNNM        WQCNNM                         Country Name
     C                   CALL      'QDCXLATE'
     C                   PARM      30            WQA5N             5 0          Len
     C                   PARM      #2CNNM        WQCNNM                         Country Name
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
 
      ** Load SFL page.
 
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   EXSR      BBLDSF
 
     C     BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     BBLDSF        BEGSR
 
      ** Load subfile page.
      ** Re-establish fields in read-ahead record.
 
     C   27              DO
     C  N82              READP     GPCTRYD0                               90    *
     C  N82              READ      GPCTRYD0                               90    *
     C                   END
 
      ** Setof record error indicators.
 
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(34)
 
      ** Start at previous highest record in SFL.
 
     C                   Z-ADD     ##RRMX        ##RR              5 0
 
      ** Reset count of DBF records read.
 
     C                   Z-ADD     *ZERO         ##RRRD            5 0
 
      ** Load next SFL page until SFL page full,
      ** or scan limit reached,
      ** or end of file reached.
 
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
 
      ** Check selection fields - if fail, read next record.
 
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     A4LCD         CABNE     #2LCD         CD020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C                   END
     C     #2ISOC        IFNE      *BLANK                                       ISO Country cod
     C     A4ISOC        CABNE     #2ISOC        CD020                          ISO Country cod
     C                   END
     C     #2RGCD        IFNE      *BLANK                                       Region Code
     C     A4RGCD        CABNE     #2RGCD        CD020                          Region Code
     C                   END
     C     #2CNNM        IFNE      *BLANK                                       Country Name
 
      ** Scan for search string.
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    A4CNNM                         Country Name
     C                   PARM      30            WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQCNNM                         Mask
     C                   PARM      30            WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             CD020
     C                   END
 
     C     CFT004        IFEQ      'Y'
     C     #2BBAN        ANDNE     *BLANK                                       BBAN Total lgth
     C                   MOVE      A4BBAN        WKBBAN            2
     C     WKBBAN        CABNE     #2BBAN        CD020
     C                   ENDIF
 
     C     CFT004        IFEQ      'Y'
     C     #2BBRL        ANDNE     *BLANK                                       BBAN Bank lgth
     C                   MOVE      A4BBRL        WKBBRL            2
     C     WKBBRL        CABNE     #2BBRL        CD020
     C                   ENDIF
 
      ** Load SFL fields.
 
     C                   EXSR      MBFL#1
 
      ** Output to subfile.
 
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
 
     C     CD020         TAG
 
      ** Increment scan check count.
 
     C                   ADD       1             ##RRRD
 
      ** Read next record.
 
     C                   READ      GPCTRYD0                             8782    *82=EOF
     C                   END                                                    WOD
 
      ** If no DBF records found, display error message.
 
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
 
      ** Send message '*No data to display'
 
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
 
      ** Save highest SFL record load can continue at end point.
 
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
 
      ** If scan limit reached, display error message.
 
     C     ##RRRD        IFGE      W0SLM
 
      ** Send message '*Scan limit reached'
 
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   END
      *
     C     BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     CAEXFM        BEGSR
 
      ** Display screen.
      ** Update screen time.
 
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
 
      ** PUTOVR unless conditioned fields change.
 
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
 
      ** If help requested, display help text.
 
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
 
      ** Update job time.
 
     C                   TIME                    ##JTM                          Job time.
 
      ** Clear messages from program message queue.
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
 
      ** Reset first message only flag.
 
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8883    *
     C     CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     DAPR##        BEGSR
 
      ** Process screen input.
      ** Maintain subfile position where possible.
 
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
 
     C     *IN81         IFEQ      '1'
 
      ** Process subfile records.
 
     C                   EXSR      DBPRSF
 
      ** If error, exit subroutine:
 
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END
 
      ** Change of position specified.
 
     C     WZLCD         CASNE     #2LCD         FBRQRL                         Last Change Dat
     C     WZTYLC        CASNE     #2TYLC        FBRQRL                         Type of Last Ch
     C     WZISOC        CASNE     #2ISOC        FBRQRL                         ISO Country cod
     C     WZCNCD        CASNE     #2CNCD        FBRQRL                         Country Code
     C     WZRGCD        CASNE     #2RGCD        FBRQRL                         Region Code
     C     WZCNNM        CASNE     #2CNNM        FBRQRL                         Country Name
     C     WZBBAN        CASNE     #2BBAN        FBRQRL                         BBAN tot. lngthCFT00
     C     WZBBRL        CASNE     #2BBRL        FBRQRL                         BBAN bank lngthCFT00
     C                   END
 
     C     DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     DBPRSF        BEGSR
 
      ** Process modified subfile records.
      ** Read first changed record (if any).
 
     C                   READC     #SFLRCD                                88    *
     C     *IN88         DOWEQ     '0'
     C                   EXSR      DCSFRC
     C                   MOVEL     *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
      ** Read next record.
     C                   READC     #SFLRCD                                88    *
     C                   END
 
     C     DBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     DCSFRC        BEGSR
 
      ** Process subfile record.
      ** Setof error indicators and SFLNXTCHG.
 
     C                   MOVEA     WKINDS        *IN(34)
     C                   SETOFF                                       84        *
 
      ** Check selection option
 
     C     #1SEL         CASEQ     '1'           DESLRC
     C                   END
 
     C     DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     DESLRC        BEGSR
 
      ** Select record & return to calling program
      ** Move record values to parameters.
 
     C                   MOVEL     #1CNCD        P1CNCD                         Country Code
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
 
     C     DEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     FBRQRL        BEGSR
 
      ** Request subfile reload.
 
     C                   MOVEL     'Y'           W0RSF
 
     C     FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     MBFL#1        BEGSR
 
      ** Move GPCTRYD0 fields to #SFLRCD
 
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     A4LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A4ISOC        #1ISOC                         ISO Country cod
     C                   MOVEL     A4CNCD        #1CNCD                         Country Code
     C                   MOVEL     A4RGCD        #1RGCD                         Region Code
     C                   MOVEL     A4CNNM        #1CNNM                         Country Name
     C                   MOVEL     A4BBAN        #1BBAN                         BBAN tot. lngthCFT00
     C                   MOVEL     A4BBRL        #1BBRL                         BBAN bank lngthCFT00
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
 
     C     MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     MEIZ#2        BEGSR
 
      ** Initialise subfile control.
 
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #2ISOC                         ISO Country cod
     C                   MOVEL     P1CNCD        #2CNCD                         Country Code
     C                   MOVEL     *BLANK        #2RGCD                         Region Code
     C                   MOVEL     *BLANK        #2CNNM                         Country Name
     C                   MOVEL     *BLANK        #2BBAN                         BBAN tot. lngth
     C                   MOVEL     *BLANK        #2BBRL                         BBAN bank lngth
 
      ** Drop ? from positioning key fields.
 
     C                   MOVEL     #2CNCD        W0X1              1
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2CNCD        W0CNCD          - 1
     C                   MOVE      #2CNCD        W0CNCD
     C                   MOVEL     W0CNCD        #2CNCD                         Country Code
     C                   MOVE      ' '           #2CNCD
     C                   END
 
     C     MEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZASNMS        BEGSR
 
      ** Send message to program's message queue.
 
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
 
      ** Clear all fields for default mechanism next time.
 
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
 
     C     ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZHHPKY        BEGSR
 
      ** Display HELP text.
 
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
 
     C     ZHEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** Cancel & exit program.
      ** Send message '*No value selected'
 
     C                   MOVEL     'Y2U0016'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   MOVEL     '*PRV '       ZAPGRL                         Pgmq rel.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVEL     'Y2U0016'     P0RTN
     C                   EXSR      ZYEXPG
 
     C     ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Exit program: Direct.
      ** Terminate program.
 
     C                   SETON                                        LR
 
      ** Exit program.
     C                   RETURN
 
     C     ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZZINIT        BEGSR
 
      ** Initialisation.
 
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
 
      ** Setup job date/time.
 
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
 
      ** Define work field Midas Run Date
 
     C                   MOVEL     *BLANK        WUMRDT            7
 
      ** Define work field Run day number
 
     C                   Z-ADD     *ZERO         WURDNB            5 0
 
      ** Define work field Set Up Complete
 
     C                   MOVEL     *BLANK        WUSUC             1
 
      ** Define work field Date format flag
 
     C                   MOVEL     *BLANK        WUDFF             1
 
      ** Define work field Multi-branching Indicator
 
     C                   MOVEL     *BLANK        WUMBIN            1
     C                   MOVEL     'SEL'         W0PMD             3            Program Mode
 
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C                   Z-ADD     500           W0SLM             5 0          SCAN LIMIT
 
      ** USER: Initialise program
      ** Standard RPG Creation PAR - Standard Functions  *
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
 
      ** Copyright Statement - Standard Functions  * copyright
      ** Clear subfile control fields.
 
     C                   EXSR      MEIZ#2
 
      ** Check if CFT004 is switched on
 
     C                   CALL      'GPAOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      *ON           *IN39
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   MOVE      *OFF          *IN39
     C                   MOVE      'N'           CFT004
     C                   ENDIF
 
     C     ZZEXIT        ENDSR
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2006

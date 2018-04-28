     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Select PDP Priority Group ID')                *
     F*****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD00321S - Midas SD Select PDP Priority Group ID             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CLE164  *CREATE    Date 18Aug14               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************
 
     FSD00321S# CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
     FSDPRGPI0  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
 
      /EJECT
 
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
 
     D JBDTTM          DS
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
 
     D YARTCM          DS           512
     D  DUMMY1                 1      1
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D P1PARM          DS
     D  P1PGID                 1      3
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1PGID        PARM      P1PGID        WP0001            3
 
      ** Initialize
 
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL
 
      ** Initialise & load subfile page
 
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
 
     C                   EXSR      CAEXFM
      *****************************************************************
      *                                                               *
      *  Process Responses
      *                                                               *
      *****************************************************************
 
      ** Cancel & exit program
 
     C   03              CAS                     ZXEXPG
 
      ** HOME: Request subfile reload
 
     C   05              CAS                     FBRQRL
 
      ** Display next SFL page
 
     C   27              CAS                     BBLDSF
 
      ** Process screen input
 
     C                   CAS                     DAPR##
 
     C                   END
 
     C                   END
     C                   END
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    BAIZSF - Initialize and Load Subfile Pages                 *
      *                                                               *
      *****************************************************************
     C     BAIZSF        BEGSR
 
      * Clear subfile
 
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
 
      ** Reset no of records in subfile
 
     C                   Z-ADD     *ZERO         ##RRMX            5 081
 
      ** Position DBF file
 
     C     KPOS          KLIST
     C                   KFLD                    PGPGID
 
      ** Setup key
 
     C                   MOVEL     #2PGID        PGPGID
     C     KPOS          SETLL     SDPRGPD0
     C                   READ      SDPRGPD0                             8782
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #2PGID        WZPGID
     C                   MOVEL     #2PGID        WZPGID
     C     *LIKE         DEFINE    #2DESC        WZDESC
     C                   MOVEL     #2DESC        WZDESC
 
      ** Translate search mask for text field
 
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2DESC        WQDESC
     C                   CALL      'QDCXLATE'
 
      ** Length
 
     C                   PARM      50            WQA5N             5 0
     C                   PARM      #2DESC        WQDESC
     C                   PARM                    WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
      ** Load subfile page
 
     C                   Z-ADD     *ZERO         ##RROK            5 0
 
     C                   EXSR      BBLDSF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    BBLDSF - Load Subfile Pages                                *
      *                                                               *
      *****************************************************************
     C     BBLDSF        BEGSR
 
      ** Re-establish fields in read-ahead record
 
     C   27              DO
     C  N82              READP     SDPRGPD0                               90
     C  N82              READ      SDPRGPD0                               90
     C                   END
 
      ** Setof record error indicators
 
     C                   MOVE      *ALL'0'       WKINDS            3
     C                   MOVEA     WKINDS        *IN(33)
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     ##RRMX        ##RR              5 0
 
      ** Reset count of DBF records read
 
     C                   Z-ADD     *ZERO         ##RRRD            5 0
 
      ** Set required pages based on *Set Cursor or *Subfile Pages
 
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
 
      ** Compute lines required based on pages
 
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
 
      ** Load next SFL page until SFL page full,
      ** or scan limit reached, or end of file reached
 
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
 
      ** Check selection fields - if fail, read next record
 
     C     #2DESC        IFNE      *BLANK
 
      ** Scan for search string
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    PGDESC
      ** Length
     C                   PARM      50            WQA3N             3 0
      ** Start
     C                   PARM      1             WQB3N             3 0
      ** Mask
     C                   PARM                    WQDESC
      ** Length
     C                   PARM      50            WQC3N             3 0
      ** Translate
     C                   PARM      '1'           WQD1              1
      ** Trim
     C                   PARM      '1'           WQE1              1
      ** Wild
     C                   PARM      '?'           WQF1              1
      ** Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
     C                   END
 
      ** Load SFL fields
 
     C                   EXSR      MBFL#1
 
      ** Output to subfile
 
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81
 
      ** If SFLRCD invalid, note that errors present
 
     C   98
     CANN99              SETON                                        99
     C                   WRITE     #SFLRCD
 
     C     CD020         TAG
 
      ** Increment scan check count
 
     C                   ADD       1             ##RRRD
 
     C                   READ      SDPRGPD0                             8782
     C                   END
 
      ** If no DBF records found, display error message
 
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
 
      ** Send message '*No data to display'
 
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
 
      ** Save highest SFL record load can continue at end point
 
     C     ##RR          IFGT      ##RRMX
 
      ** Calculate top line
 
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
 
      ** If scan limit reached, display error message
 
     C     ##RRRD        IFGE      W0SLM
 
      ** Send message '*Scan limit reached'
 
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    CAEXFM - Display Screen                                    *
      *                                                               *
      *****************************************************************
     C     CAEXFM        BEGSR
 
      ** Update screen time
 
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
 
      ** PUTOVR unless conditioned fields change
 
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
 
      ** Set cursor by *SET CURSOR data
 
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
 
      ** Maintain subfile position where possible
 
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
 
      ** Test cursor
 
     C                   EXSR      Y8TST
 
      ** Clear set cursor DDS indicator
 
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94
     C                   END
     C                   MOVE      *BLANK        WCSRLC
 
      ** If help requested, display help text
 
     C   25              EXSR      ZHHPKY
     C                   END
 
      ** Update job time
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
      ** Reset first message only flag
 
     C                   MOVEL     'Y'           ZAFSMS            1      99
     C                   SETOFF                                         9283
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    DAPR## - Process Screen Inputs                             *
      *                                                               *
      *****************************************************************
     C     DAPR##        BEGSR
 
     C     *IN81         IFEQ      '1'
 
      ** Process subfile records
 
     C                   EXSR      DBPRSF
 
      ** If error, exit subroutine:
 
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END
 
      ** Change of position specified
 
     C     WZPGID        CASNE     #2PGID        FBRQRL
     C     WZDESC        CASNE     #2DESC        FBRQRL
 
     C                   END
 
     C     DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    DBPRSF - Process Modified Subfile Record                   *
      *                                                               *
      *****************************************************************
     C     DBPRSF        BEGSR
 
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
 
      ** Process subfile record
 
     C                   EXSR      DCSFRC
     C                   MOVEL     *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
 
      ** Read next record
 
     C                   READC     #SFLRCD                                92
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    DCSFRC - Process Subfile Record                            *
      *                                                               *
      *****************************************************************
     C     DCSFRC        BEGSR
 
      ** Set off error indicators and SFLNXTCHG
 
     C                   MOVEA     WKINDS        *IN(33)
     C                   SETOFF                                       84
 
      ** Check selection option
 
     C     #1SEL         CASEQ     '1'           DESLRC
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    DESLRC - Select & Return to Calling Program                *
      *                                                               *
      *****************************************************************
     C     DESLRC        BEGSR
 
      ** Move record values to parameters
 
     C                   MOVEL     #1PGID        P1PGID
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
 
     C     DEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    FBRQRL - Request Subfile Reload                            *
      *                                                               *
      *****************************************************************
     C     FBRQRL        BEGSR
 
     C                   MOVEL     'Y'           W0RSF
 
     C     FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    MBFL#1 - Move SDPRGPD0 Fields to #SFLRCD                   *
      *                                                               *
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     PGPGID        #1PGID
     C                   MOVEL     PGDESC        #1DESC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    MEIZ#2 - Initialize Subfile Control                        *
      *                                                               *
      *****************************************************************
     C     MEIZ#2        BEGSR
 
     C                   MOVEL     P1PGID        #2PGID
     C                   MOVEL     *BLANK        #2DESC
 
      ** Drop ? from positioning key fields
 
     C                   MOVEL     #2PGID        W0X1              1
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2PGID        W0PGID          - 1
     C                   MOVE      #2PGID        W0PGID
     C                   MOVEL     W0PGID        #2PGID
     C                   MOVE      ' '           #2PGID
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    Y0SET - Set Cursor by *SET CURSOR Data                     *
      *                                                               *
      *****************************************************************
     C     Y0SET         BEGSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    Y8TST - Test Cursor                                        *
      *                                                               *
      *****************************************************************
     C     Y8TST         BEGSR
 
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    Y9CLR - Clear *SET CURSOR Data                             *
      *                                                               *
      *****************************************************************
     C     Y9CLR         BEGSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZASNMS - Send Message to Program's Message Queue           *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      ** Clear all fields for default mechanism next time
 
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZHHPKY - Display HELP Text                                 *
      *                                                               *
      *****************************************************************
     C     ZHHPKY        BEGSR
 
      ** Signal help request
 
     C                   MOVEL     'Y'           W0HLP             1
 
      ** Extract cursor row and column
 
     C     @#RWCL        DIV       256           ZHCSRW            5 0
     C                   MVR                     ZHCSCL            5 0
 
      ** Save cursor position for redisplay
 
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0
 
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10
     C                   PARM      *BLANK        YYHPFL           10
     C                   PARM      *BLANK        YYHPLB           10
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10
     C                   PARM      '*NORMAL'     YYUSOP           10
     C                   PARM      ZHCSRW        YYRW              5 0
     C                   PARM      ZHCSCL        YYCL              5 0
     C                   PARM      *ZERO         YYLGCT            5 0
     C                   PARM      *BLANK        YYLGVN           10
 
      ** Clear set cursor DDS indicator
 
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZXEXPG - Cancel & Exit Program                             *
      *                                                               *
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** Send message '*No value selected'
 
     C                   MOVEL     'Y2U0016'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     '*PRV '       ZAPGRL
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y2U0016'     P0RTN
     C                   EXSR      ZYEXPG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZYEXPG - Exit Program: Direct                              *
      *                                                               *
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Terminate program
 
     C                   SETON                                        LR
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZZINIT - Initialization                                    *
      *                                                               *
      *****************************************************************
     C     ZZINIT        BEGSR
 
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
 
      ** Setup job date/time
 
     C                   Z-ADD     UDATE         ##JDT
 
      ** Set century digit (If YY prior to 1940 treat as 20YY)
 
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
 
      ** Update screen time
 
     C                   TIME                    ##TME             6 0
 
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
 
      ** Flag no *SET CURSOR in the program
 
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
 
      ** Define *Synon program work fields
 
     C                   MOVEL     *BLANKS       W0CFL            10
     C                   Z-ADD     *ZEROS        W0CRW             5 0
     C                   Z-ADD     *ZEROS        W0CCL             5 0
 
      ** Move main file information to JOB context
 
     C                   MOVE      @1FFL         ZZFFL            10
     C                   MOVE      @1FLB         ZZFLB            10
     C                   MOVE      @1FMB         ZZFMB            10
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21
 
      ** Open files
 
     C                   OPEN      SD00321S#
     C                   OPEN      SDPRGPI0
     C                   MOVEL     'N'           W0PMT             1
 
      ** Program mode
 
     C                   MOVEL     'SEL'         W0PMD             3
 
     C                   Z-ADD     14            ##SFPG            3 0
     C                   Z-ADD     1             ##SFRC
 
      ** Maximum record number
 
     C                   Z-ADD     *ZERO         ##RRMX
 
      ** Scan limit
 
     C                   Z-ADD     500           W0SLM             5 0
 
      ** Subfile pages
 
     C                   Z-ADD     1             W0SPG             3 0
 
      ** Processed Subfile record
 
     C                   Z-ADD     0             W0RR0             4 0
     C                   MOVEL     *BLANK        W0GRP             1
 
      ** USER: Initialize program
      ** SD0270S PRECOMPILER - Facility Types
      ** Copyright Statement 1988 - Standard Functions
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
     C                   Z-ADD     99999         W0SLM
 
      ** Clear subfile control fields
 
     C                   EXSR      MEIZ#2
 
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
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Commodity Details Enquiry')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD002102 - Midas SD Commodity Details Enquiry                *
      *                                                               *
      *  Function:  This program displays commodity details.          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CMG003  *CREATE    Date 04Oct12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *                                                               *
      *****************************************************************
     FSD002102DFCF   E             WORKSTN INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** Midas SD Commodity Details Display file
 
     FSDCMDTL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      ** Midas SD Commodity Details File Retrieve
 
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Currency Details File Retrieve
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
 
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
      ** File information data structure
 
     D PARC            DS             3
     D  PACYCD                 1      3
 
     D PBRC            DS             3
     D  PBCYCD                 1      3
 
     D A@CPY           DS
     D  CPY@                   1     80    DIM(1) CTDATA PERRCD(1)
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D ID0001          DS           528
      ** File information data structure
 
 
     D P1PARM          DS             3
     D  P1CYCD                 1      3
 
     D P2PARM          DS
     D  CMG003                 1      1
 
     D P3PARM          DS
     D  P3WRTC                 1      5
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
     C     P3WRTC        PARM      P3WRTC        WP0002            5
 
      ** Initialize
 
     C                   EXSR      ZZINIT
 
      ** Check passed parameters
 
     C                   EXSR      FACKPM
 
      ** Perform once if all passed, else repeat
 
     C     W0RPT         DOUEQ     'N'
 
      ** Display and process key screen
 
     C                   EXSR      BADSKY
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BADSKY - Display and process key screen                      *
      *                                                               *
      *****************************************************************
     C     BADSKY        BEGSR
 
      ** Initialize key screen
 
     C                   MOVEL     P1CYCD        #1CYCD
     C                   MOVEL     'Y'           W0BYP             1
 
      ** Signal start of transaction
 
     C                   MOVEL     'Y'           W0TRN             1
     C                   DOW       W0TRN = 'Y' OR W0TRN = 'K'
 
      ** Ensure transaction continues (if reset)
 
     C                   MOVEL     'Y'           W0TRN
 
     C                   DOW       W0TRN = 'Y'
 
     C                   IF        W0BYP = 'Y'
     C                   IF        #1CYCD = *BLANKS OR *IN05 = '1'
     C                   MOVEL     'N'           W0BYP
     C                   ENDIF
     C                   ENDIF
 
      ** Bypass key screen
 
     C                   IF        W0BYP <> 'Y'
     C                   EXSR      BBEXFM
     C                   ENDIF
 
     C                   MOVEL     'N'           W0BYP
 
      ** Process response to key screen
 
     C   03              CAS                     ZXEXPG
     C   05              CAS                     BDHMKY
     C                   CAS                     BEPRKY
     C                   ENDCS
 
     C                   DOW       W0TRN = 'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   ENDDO
 
     C                   ENDDO
     C                   ENDDO
 
     C     BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BBEXFM - Display key screen and process HELP requests        *
      *                                                               *
      *****************************************************************
     C     BBEXFM        BEGSR
 
      ** Update screen time
 
     C                   TIME                    ##TME
     C                   DOU       W0HLP = 'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
 
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
     C                   SETON                                            86
 
      ** Test cursor
 
     C                   EXSR      Y8TST
 
      ** Clear set cursor DDS indicator
 
     C                   IF        WCSRLC = 'OFF'
     C                   SETOFF                                       94
     C                   ENDIF
 
     C                   MOVE      *BLANK        WCSRLC
 
      ** If help requested, display help text
 
     C   25              EXSR      ZHHPKY
     C                   ENDDO
 
      ** Update job time
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEL     'Y'           ZAFSMS            1
 
     C     BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BDHMKY - Process HOME key                                    *
      *                                                               *
      *****************************************************************
     C     BDHMKY        BEGSR
 
     C                   MOVEL     'N'           W0TRN
 
     C     BDEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BEPRKY - Process key screen input                            *
      *                                                               *
      *****************************************************************
     C     BEPRKY        BEGSR
 
      ** Initialise detail screen
 
     C                   EXSR      MAIZ#1
 
      ** Validate key fields
 
     C                   EXSR      BFVLKY
 
     C     *IN99         CABEQ     '1'           BEEXIT
 
      ** Check for existing record for Currency
 
     C     KRTV          KLIST
     C                   KFLD                    A6CYCD
     C                   MOVEL     #1CYCD        A6CYCD
     C     KRTV          CHAIN     @A6REA3                            9091
 
     C                   IF        *IN91 = '1'
     C                   SETON                                        9931
     C                   GOTO      BEEXIT
     C                   ENDIF
 
     C                   IF        *IN90 = '1'
     C                   SETON                                        9931
 
      ** Send message 'Currency Codes         NF'
 
     C                   MOVEL     'USR0071'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      #1CMSN = A6CYCD + '-' + A6SWCY
     C                   EVAL      #1CMSC = A6SWCY
     C     #1CMSN        CHAIN     SDCMDTL1                           9091
 
     C                   IF        *IN90 = '1'
     C                   EXSR      MAIZ#1
     C                   ELSE
     C                   EXSR      MBFL#1
     C                   ENDIF
     C                   ENDIF
 
     C   99              GOTO      BEEXIT
 
      ** No error: Display and process details
 
     C                   EXSR      CADSDA
 
     C     BEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BFVLKY - Validate key fields                                 *
      *                                                               *
      *****************************************************************
     C     BFVLKY        BEGSR
 
     C                   EXSR      VACKRL
 
      ** USER: Validate key screen
      ** Currency Code required
 
     C     #1CYCD        IFEQ      *BLANK
     C                   SETON                                        9931
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C     BFEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CADSDA - Display and process detail screen                   *
      *                                                               *
      *****************************************************************
     C     CADSDA        BEGSR
 
      ** Conduct detail screen conversation
      ** Repeat until screen control flag is reset:
 
     C                   DOW       W0TRN = 'Y'
 
      ** Display detail screen
 
     C                   EXSR      CBEXFM
 
     C   03              CAS                     ZXEXPG
     C   12              CAS                     CCDSPV
     C   05              CAS                     CCDSPV
     C                   CAS                     CFPRSC
     C                   END
 
     C                   ENDDO
 
     C     CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CBEXFM - Display screen and process HELP requests            *
      *                                                               *
      *****************************************************************
     C     CBEXFM        BEGSR
 
     C                   EXSR      GBDSAD
 
      ** Update screen time
 
     C                   TIME                    ##TME
 
     C                   DOU       W0HLP = 'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
 
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   SETON                                        86
 
     C                   EXSR      Y8TST
 
     C                   IF        WCSRLC = 'OFF'
     C                   SETOFF                                       94
     C                   ENDIF
 
     C                   MOVE      *BLANK        WCSRLC
     C   25              EXSR      ZHHPKY
     C                   END
 
     C                   TIME                    ##JTM
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEL     'Y'           ZAFSMS            1      99
 
     C     CBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CCDSPV - Redisplay previous screen                           *
      *                                                               *
      *****************************************************************
     C     CCDSPV        BEGSR
 
      ** USER: Process key screen request
 
     C                   MOVEL     'USR0790'     P0RTN
     C                   EXSR      ZYEXPG
     C   05              MOVEL     'Y'           W0TRN
     C   12              MOVEL     'K'           W0TRN
 
     C     CCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CFPRSC - Validate Commodity fields details                   *
      *                                                               *
      *****************************************************************
     C     CFPRSC        BEGSR
 
     C                   MOVEL     'N'           W0DCF             1
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      DCVLDL
 
      ** QUIT if error:
      ** Defer confirm/update requested
      ** No error: update record
 
     C   99              GOTO      CFEXIT
     C     W0DCF         CABEQ     'Y'           CFEXIT
 
     C     CFEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DCVLDL - Validate Commodity details                          *
      *                                                               *
      *****************************************************************
     C     DCVLDL        BEGSR
 
      ** F8 pressed for further records
 
     C                   IF        *IN08 = '1'
 
      ** No further screen to show
 
     C     WULTPM        IFEQ      'Y'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ENDIF
 
      ** USER: Validate detail screen
      ** ENTER pressed
 
     C                   MOVEL     *BLANK        P3WRTC
     C                   MOVEL     'PEND'        P3WRTC
 
      ** F12 pressed, seton 99 to force redisplay
 
     C                   IF        P0RTN = 'USR0790'
     C                   SETON                                        99
     C                   ELSE
     C                   EXSR      ZYEXPG
     C                   ENDIF
 
     C     DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FACKPM - Check passed parameters                             *
      *                                                               *
      *****************************************************************
     C     FACKPM        BEGSR
 
      ** Is full key present?
 
     C     P1CYCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
     C                   MOVEL     'N'           W0RPT
     C                   ENDIF
 
     C     FAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GBDSAD - Set detail screen conditioning indicators           *
      *                                                               *
      *****************************************************************
     C     GBDSAD        BEGSR
     C                   SETON                                        8788
     C     GBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIZ#1 - Initialise Commodity screen fields                  *
      *                                                               *
      *****************************************************************
     C     MAIZ#1        BEGSR
 
     C                   EVAL      #1CMSN = *BLANKS
     C                   EVAL      #1CMSC = *BLANKS
     C                   EVAL      #1CMTP = *BLANKS
     C                   EVAL      #1CMTD = *BLANKS
     C                   EVAL      #1CMDN = *BLANKS
     C                   EVAL      #1CMFM = *BLANKS
     C                   EVAL      #1CMUN = *BLANKS
     C                   EVAL      #1CMUT = *BLANKS
     C                   EVAL      #1CMUD = *BLANKS
 
     C     MAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MBFL#1 - Move Commodity file details to screen fields        *
      *                                                               *
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   EVAL      #1CMSN = A6CMSN
     C                   EVAL      #1CMSC = A6CMSC
     C                   EVAL      #1CMTP = A6CMTP
     C                   EVAL      #1CMTD = A6CMTD
     C                   EVAL      #1CMDN = A6CMDN
     C                   EVAL      #1CMFM = A6CMFM
     C                   EVAL      #1CMUN = A6CMUN
     C                   EVAL      #1CMUT = A6CMUT
     C                   EVAL      #1CMUD = A6CMUD
 
     C     MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VACKRL - Select existing record                              *
      *                                                               *
      *****************************************************************
     C     VACKRL        BEGSR
 
     C                   MOVEL     #1CYCD        WK1X01            1
 
     C                   IF        WK1X01 = '?'
     C                   CALL      'SD0020S'                            90
     C                   PARM      *BLANK        W0RTN             7
     C     #1CYCD        PARM      #1CYCD        WQ0001            3
 
     C                   IF        *IN90 = '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0020S'     W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Error detected?
 
     C                   IF        W0RTN <> *BLANKS AND W0RTN <> 'Y2U0016'
     C                   SETON                                        99
     C                   ENDIF
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     VAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Y8TST - Test cursor                                          *
      *                                                               *
      *****************************************************************
     C     Y8TST         BEGSR
 
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
 
     C     Y8EXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS- Send message to program's message queue              *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   IF        ZAPGMQ = *BLANKS
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
      ** If no message file specified, use default
 
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   ENDIF
 
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
 
     C     ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZHHPKY - Display HELP text                                   *
      *                                                               *
      *****************************************************************
     C     ZHHPKY        BEGSR
 
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
     C                   PARM      1             YYLGCT            5 0
     C                   PARM      W0GRP         YYLGVN           10
 
      ** Clear set cursor DDS indicator
 
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94
 
     C     ZHEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZXEXPG - Cancel and exit from key screen                     *
      *                                                               *
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** USER: Exit program processing
      ** CASE: KEY.*CMD key is *Exit
 
     C                   IF        *IN03 = '1'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
 
     C     ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZYEXPG - Exit program: Direct                                *
      *                                                               *
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Terminate program
      ** Exit program
     C                   SETON                                        LR
     C                   RETURN
 
     C     ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZZINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     ZZINIT        BEGSR
 
     C                   IF        W0ICL = *BLANKS
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
 
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
 
     C                   Z-ADD     UDATE         ##JDT
 
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
 
     C                   TIME                    ##TME             6 0
 
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
 
     C                   MOVEL     *BLANK        WUMRDT            7
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   MOVEL     *BLANK        WULTPM            1
     C                   MOVEL     'Y'           WULTPM            1
     C                   MOVEL     *BLANK        WUWRTC            5
     C                   MOVEL     *BLANK        WUSUC             1
     C                   MOVEL     *BLANK        WUDFF             1
     C                   MOVEL     *BLANK        WUMBIN            1
     C                   MOVE      *BLANK        WCSRLC            3
 
     C                   Z-ADD     *ZEROS        W0CRW             5 0
     C                   Z-ADD     *ZEROS        W0CCL             5 0
 
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
 
     C                   OPEN      SDCMDTL1
 
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
 
      ** USER: Initialize program
      ** Copyright Statement 1999 - Standard Functions  * copyright
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   MOVE      MRDT          ##MRDT            7
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
 
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
 
      ** F3=Main Menu   F12=Previous
 
     C                   MOVEL     'USR3346'     WUMSID            7
     C                   CALL      'SDRTVTXT'                           90
     C     WUMSID        PARM      WUMSID        WQ0286            7
     C     WUMSGF        PARM      WUMSGF        WQ0287           10
     C     WUMTXT        PARM      WUMTXT        WQ0288           80
     C                   MOVEL     WUMTXT        ##CTX1
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
 
     C     ZZEXIT        ENDSR
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
 
     C                   DUMP
     C                   ROLBK
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**CTDATA CPY@
(c) Finastra International Limited 2012

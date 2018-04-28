     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Message type descrip maintenance subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Midas/TI Interface                                   *
      *                                                               *
      *  TI0508 - TI Incoming Midas Message Selection Maintenance     *
      *                                                               *
      *  Function:  This module will display a sub-file of the view   *
      *             TIIMMSL0, allowing the contents to be inserted,   *
      *             amended and deleted.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CTI004  *CREATE    Date 12Apr04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Routing Swift Messages                              *
      *                                                               *
      *****************************************************************
 
     FTI0508DF  CF   E             WORKSTN SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
 
     FTIIMMSL1  IF   E           K DISK    INFDS(INFDS1)
 
     FTIIMMSL0  UF A E           K DISK    USROPN
 
     FSDMTPYL0  IF   E           K DISK
 
     D @CN             S             25    DIM(6) CTDATA PERRCD(1)
 
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
 
      ** Program data structure.
 
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Display file data structure.
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
 
      ** File information data structure.
 
     D @1DBRC        E DS                  EXTNAME(TIIMMSL0)
 
      ** Current/previous master file format fields for change control.
 
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
 
     D A@CPY           DS
 
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
     D WCOND           S             65    DIM(20)
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D                 DS
     D  ZAMSDA                 1    132
     D  ZA0001                 1      3
     D  ZA0002                 1      1
     D  ZA0003                 2      4
 
      ** Parameters
 
     D ZADFMF          S             10
     D ZAPGM           S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSTP          S              7
 
      ** Declared work variables
 
     D W0HLP           S              1
     D W0DCF           S              1
     D W0RSF           S              1
     D W0RTN           S              7
     D W0HPMB          S              1
     D W0NLR           S              1
     D W0PMD           S              3
     D WMSGF           S              8
     D WRRMX           S              5  0
 
     D ##RRMX          S              5  0
     D ##RROK          S              5  0
     D ##RR            S              5  0
     D ##TME           S              6  0
     D ##SFPG          S              3  0
 
     D WUMRDT          S              7
     D WUSUC           S              1
     D WUDFF           S              1
     D WUMBIN          S              1
 
     D WURDNB          S              5  0
     D WUNORC          S              5  0
     D WUNOIN          S              5  0
     D WUNOAM          S              5  0
     D WUNODL          S              5  0
     D X               S              1  0
 
     D YYHPFL          S             10
     D YYHPLB          S             10
 
     D WUTQKF          S              1
     D WUIVKF          S              1
     D WKIPIN          S              1
 
     D WKIND0          S              3
     D WKIND1          S              3
     D CAIN89          S              1
     D CAIN81          S              1
     D WWork1          S              1
 
     D WColPos         S              2  0
     D WTag20          S              2  0
     D WTag21          S              2  0
     D WComa           S              2  0
     D WNo             S              2  0
     D WStrt           S              2  0
     D WEnd            S              2  0
     D WLent           S              2  0
     D WLent1          S              2  0
     D WX              S              2  0
     D WZ              S              2  0
     D WTag            S              4
     D WVal            S             65
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise
 
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page.
 
     C                   EXSR      BAIZSF
     C                   EVAL      W0RSF = 'N'
 
      * Display screen until reload requested:
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen.
 
     C                   EXSR      CAEXFM
 
      ** Process response:
      ** Exit request: Cancel & exit program.
 
     C     *IN03         CASEQ     *ON           ZXEXPG
 
      ** HOME: Request subfile reload.
 
     C     *IN05         CASEQ     *ON           FBRQRL
 
      ** Display next SFL page.
 
     C     *IN27         CASEQ     *ON           BBLDSF
 
      ** Process screen input.
     C                   CAS                     DAPR##
     C                   ENDCS
 
     C                   ENDDO
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BAIZSF    - Initialise & Load subfile page.                  *
      *                                                               *
      *****************************************************************
     C     BAIZSF        BEGSR
 
      ** Clear subfile.
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     #SFLCTL
     C                   EVAL      *IN80 = *OFF
 
      ** Reset no of records in subfile.
 
     C                   Z-ADD     *ZERO         WRRMX                81
 
      ** If CHANGE mode, then position file:
 
     C                   IF        W0PMD <> 'ADD'
     C     *LIKE         DEFINE    #2MTPY        WZMTPY
     C                   MOVEL     #2MTPY        WZMTPY
 
     C     KPOS          KLIST
     C                   KFLD                    TIMSG
 
      ** Setup key.
 
     C                   EVAL      TIMSG = #2MTPY
     C     KPOS          SETLL     TIIMMSD1                           82
     C                   IF        *IN82 = *OFF
     C                   READ      TIIMMSD1                             7182
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
      ** Load subfile page.
 
     C                   EXSR      BBLDSF
 
      ** If no records found, display error message.
 
     C                   IF        *IN82 = *ON AND
     C                             ##RR = 0
 
      ** Send message '*No data to display'
 
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BBLDSF   - Load subfile page (write empty page if add mode). *
      *                                                               *
      *****************************************************************
     C     BBLDSF        BEGSR
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record.
 
     C                   IF        *IN27 = *ON AND
     C                             W0PMD <> 'ADD'
     C                   IF        *IN82 = *OFF
     C                   READP     TIIMMSD1                               70
     C                   READ      TIIMMSD1                               70
     C                   ENDIF
     C                   ENDIF
 
      ** Setof record error indicators.
 
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVE      *ALL'1'       WKIND1
 
      ** Start at previous highest SFL record reached.
 
     C                   EVAL      ##RR = WRRMX
     C                   EVAL      ##RROK = 0
 
      ** Load next page of SFL:
 
     C                   DOW       ##RROK < ##SFPG AND *IN82 = *OFF
     C                   MOVEA     WKIND0        *IN(32)
     C                   EVAL      *IN87 = *OFF
 
      ** Clear SFL fields.
 
     C                   EXSR      MAIZ#1
 
      ** If change mode, load SFL fields.
 
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      MBFL#1
     C                   ENDIF
 
      * Output to subfile.
 
     C                   ADD       1             ##RR                 81
     C                   ADD       1             ##RROK
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C                   IF        W0PMD <> 'ADD'
     C                   READ      TIIMMSD1                               82
     C                   ENDIF
     C                   ENDDO
 
      * Save highest SFL rec, so load can continue at end point.
 
     C                   IF        ##RR > WRRMX
     C     WRRMX         ADD       1             ##SFRC
     C                   Z-ADD     ##RR          WRRMX
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CAEXFM    - Display screen and process HELP requests.        *
      *                                                               *
      *****************************************************************
     C     CAEXFM        BEGSR
 
      ** Set screen conditioning indicators.
 
     C                   EXSR      GBDSA2
 
      ** Update screen time.
 
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
 
      ** PUTOVR unless conditioned fields change.
 
     C                   EVAL      *IN86 = *ON
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   MOVE      *IN89         CAIN89
     C                   MOVE      *IN81         CAIN81
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP
 
      ** If help requested, display help text.
 
     C                   IF        *IN25 = *ON
     C                   EXSR      ZHHPKY
     C                   ENDIF
     C                   ENDDO
 
      ** Update job time.
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue.
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
 
      * Reset first message only flag.
 
     C                   MOVEL     'Y'           ZAFSMS            1      79
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DAPR##    - Process screen input.                            *
      *                                                               *
      *****************************************************************
     C     DAPR##        BEGSR
 
      * Maintain subfile position where possible.
 
     C                   IF        @#SFRC > *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
 
     C                   IF        W0PMD <> 'ADD'
 
      ** Change of position specified?
 
     C                   IF        WZMTPY <> #2MTPY
     C                   EXSR      FBRQRL
     C                   ENDIF
     C                   ENDIF
 
      ** Quit if reload requested.
 
     C                   IF        W0RSF = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        *IN81 = *ON
     C                   DO
 
      ** No data entered as yet.
 
     C                   MOVEL     'N'           WKIPIN
 
      ** Confirm/update is not defered.
 
     C                   MOVEL     'N'           W0DCF
 
      ** Process subfile records.
 
     C                   EXSR      DBPRSF
 
      ** If error, exit:
 
     C                   IF        *IN79 = *ON OR
     C                             W0DCF = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Defer confirm/update requested:
      ** If data entered.
 
     C                   IF        WKIPIN = 'Y'
 
      ** Update DBF from subfile.
 
     C                   EXSR      EAPRSF
 
      ** If error during update, exit:
 
     C                   IF        *IN79 = *ON
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** Switch between *ADD/*CHANGE modes.
 
     C                   IF        *IN09 = *ON
     C                   EXSR      FACHMD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DBPRSF    - Process modified subfile records.                *
      *                                                               *
      *****************************************************************
     C     DBPRSF        BEGSR
 
     C                   READC     #SFLRCD                                72
 
     C                   DOW       *IN72 = '0'
     C                   EXSR      DCPRSR
     C                   EVAL      *IN87 = *OFF
 
      ** Set screen conditioning indicators.
 
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                72
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DCPRSR    - Process subfile record.                          *
      *                                                               *
      *****************************************************************
     C     DCPRSR        BEGSR
 
      ** Setoff error indicators.
 
     C                   MOVEA     WKIND0        *IN(32)
     C                   EVAL      *IN78 = *OFF
     C                   EVAL      *IN84 = *OFF
 
     C                   IF        W0PMD = 'ADD'
 
      ** Check for null record.
 
     C                   EXSR      DDNLRC
     C                   IF        W0NLR = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** If not null record, continue.
 
     C                   ENDIF
 
     C                   MOVEL     'Y'           WKIPIN
     C                   EVAL      *IN84 = *ON
 
      ** If delete request, bypass validation.
 
     C                   IF        #1SEL = 'D'
     C                   LEAVESR
     C                   ENDIF
 
      ** Validate subfile record.
 
     C                   EXSR      DEV1RC
 
      ** If SFLRCD invalid, note the fact.
 
     C                   IF        *IN79 = *OFF AND *IN78 = *ON
     C                   Z-ADD     ##RR          ##SFRC               79
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DDNLRC    - Check for null record.                           *
      *                                                               *
      *****************************************************************
     C     DDNLRC        BEGSR
 
     C                   EVAL      W0NLR = 'N'
 
     C                   IF        #1MTPY <> *BLANKS OR
     C                             #1MTPD <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
 
     C                   MOVEL     'Y'           W0NLR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DEV1RC    - Validate subfile record.                         *
      *                                                               *
      *****************************************************************
     C     DEV1RC        BEGSR
 
      ** USER: Validate subfile record fields
 
     C                   MOVEL     #1MTPY        WUTQKF
     C                   MOVEL     #1MTPY        WUIVKF
 
      ** CASE:     WRK.Test ? in Key Field is Question Mark
 
     C                   IF        WUTQKF = @CN(01)
 
      ** Setup message data for message.
 
     C                   MOVEL     #1MTPY        ZA0001
 
      ** Send message 'Question Mark Invalid'
 
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN33 = *ON
 
     C                   ELSE
      ** CASE:     WRK.Test ? in Key Field is Asterisk
 
     C                   IF        WUTQKF = @CN(2)
     C                             OR WUTQKF = ' '
 
      ** Setup message data for message.
 
     C                   MOVEL     WUIVKF        ZA0002
     C                   MOVEL     #1MTPY        ZA0003
 
      ** Send message 'Key Field Invalid Value'
 
     C                   MOVEL     'USR0849'     ZAMSID
     C                   IF        WUTQKF = ' '
     C                   MOVEL     'USR0899'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN33 = *ON
 
     C                   ENDIF
 
     C     '*'           SCAN      #1MTPY        X
     C                   IF        %FOUND
 
      ** '*' cannot be preceeded by any character except ' '
 
     C                   IF        X = 2
     C                   MOVE      #1MTPY        WWork1
 
     C                   IF        WWork1 <> ' '
     C                   MOVEL     'USR1642'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE
 
      ** If message code does not contain '*', it must be a valid message
      ** type in SDMTPYPD
 
     C     #1MTPY        CHAIN     SDMTPYL0
     C                   IF        NOT %FOUND(SDMTPYL0)
     C                   MOVEL     'USR9608'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Message Type required.
 
     C                   IF        #1MTPY = *BLANK
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN33 = *ON
 
      ** Send message '*Value required'
 
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Validate subfile field #1MTPD
 
     C                   IF        #1MTPD <> *BLANK
     C                   EXSR      SRVALMTPD
     C                   IF        *IN34 = *ON
     C                   EVAL      *IN78 = *ON
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALMTPD - Validate subfile field #1MTPD                    *
      *                                                               *
      *****************************************************************
     C     SRVALMTPD     BEGSR
 
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
 
      ** Selection criteria must start with either :21: and/or :20:
 
     C     ':'           SCAN      #1MTPD        WColPos
     C                   IF        WColPos <>  1
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0091'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
 
      ** Selection criteria can't have any tag other than :21: and/or :20:
 
     C                   EVAL      WTag20 = 0
     C                   EVAL      WTag21 = 0
     C                   DOW       WColPos <> 0
     C                   EVAL      WTag = %SUBST(#1MTPD:WColPos:4)
     C                   IF        WTag <> ':20:' AND WTag <> ':21:'
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0092'     ZAMSID
     C                   LEAVESR
     C                   ELSE
 
      ** Error if either :20: and/or :21: is found more than once
 
     C                   IF        WTag = ':20:'
     C                   EVAL      WTag20 = WTag20 + 1
     C                   ELSE
     C                   EVAL      WTag21 = WTag21 + 1
     C                   ENDIF
     C                   IF        WTag20 > 1 or WTag21 > 1
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0093'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
     C                   EVAL      WColPos = WColPos + 4
     C     ':'           SCAN      #1MTPD:WColPosWColPos
     C                   ENDDO
 
      ** Selection criteria must have either :21: and/or :20:
 
     C     ':20:'        SCAN      #1MTPD
     C                   IF        NOT %FOUND
     C     ':21:'        SCAN      #1MTPD
     C                   IF        NOT %FOUND
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0094'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
      ** There should be no embedded blanks within the selection criteria
 
     C     ' '           SCAN      #1MTPD        Y                 2 0
     C                   EVAL      Y = Y + 1
     C                   DOW       Y < 66
     C                   IF        %SUBST(#1MTPD:Y:1) <> ' '
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0095'     ZAMSID
     C                   LEAVESR
     C                   ELSE
     C                   EVAL      Y = Y + 1
     C                   ENDIF
     C                   ENDDO
 
      ** If :20: and/or :21: is present it should be followed by a value.
 
     C     ':20:'        SCAN      #1MTPD        WColPos
     C                   EVAL      WColPos = WColPos + 4
     C                   IF        %FOUND
     C                   IF        %SUBST(#1MTPD:WColPos:1) = ' ' OR
     C                             %SUBST(#1MTPD:WColPos:1) = ':' OR
     C                             %SUBST(#1MTPD:WColPos:1) = ','
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0096'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
     C     ':21:'        SCAN      #1MTPD        WColPos
     C                   EVAL      WColPos = WColPos + 4
     C                   IF        %FOUND
     C                   IF        %SUBST(#1MTPD:WColPos:1) = ' ' OR
     C                             %SUBST(#1MTPD:WColPos:1) = ':' OR
     C                             %SUBST(#1MTPD:WColPos:1) = ','
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0096'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
      ** 'string', '*', '*string', 'string*', '*string*' are the only
      ** valid forms of tag values
 
     C     ':20:'        SCAN      #1MTPD        WColPos
     C                   IF        %FOUND
     C                   EXSR      SRVALTAG
     C                   ENDIF
     C     ':21:'        SCAN      #1MTPD        WColPos
     C                   IF        %FOUND
     C                   EXSR      SRVALTAG
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALTAG  - Validate value of the tag                        *
      *                                                               *
      *****************************************************************
     C     SRVALTAG      BEGSR
 
     C                   EVAL      WColPos = WColPos + 4
     C     ':'           SCAN      #1MTPD:WColPosWEnd
     C                   IF        NOT %FOUND
     C     ' '           SCAN      #1MTPD:WColPosWEnd
     C                   ENDIF
     C                   EVAL      WLent = WEnd - WColPos
     C                   EVAL      WLent1 = WLent
     C                   EVAL      WVal = %SUBST(#1MTPD:WColPos:WLent)
 
      ** Determine content of the tag. If tag's content has multiple
      ** values, store them in array WCOND
 
     C                   EVAL      WStrt = 1
     C     ','           SCAN      WVal          WComa
     C                   EVAL      WX = 1
     C                   IF        %FOUND
 
     C                   DOW       %FOUND
 
     C                   IF        WComa = WLent1
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0096'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WLent = WComa - WStrt
     C                   EVAL      WCOND(WX) = %SUBST(WVal:WStrt:WLent)
     C                   EVAL      WStrt = WComa + 1
     C     ','           SCAN      WVal:WStrt    WComa
     C                   IF        NOT %FOUND
     C     ' '           SCAN      WVal:WStrt    WComa
     C                   EVAL      WX = WX + 1
     C                   EVAL      WLent = WComa - WStrt
     C                   EVAL      WCOND(WX) = %SUBST(WVal:WStrt:WLent)
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WX = WX + 1
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WCOND(WX) = WVal
     C                   ENDIF
 
      ** Loop until checking of all values stored in array is done
 
     C                   EVAL      WNo = 1
     C                   DOW       WNo <= WX
 
     C                   EVAL      WZ = 1
     C     ' '           SCAN      WCOND(WNo)    WLent
     C                   EVAL      WLent = WLent - 1
     C                   DOW       %FOUND
     C     '*'           SCAN      WCOND(Wno):WZ WZ
     C                   IF        WZ <> 0 AND WZ <> 1 AND WZ <> WLent OR
     C                             WZ = 2 AND WLent = 2 AND WZ <> 0
     C                   EVAL      *IN34 = *ON
     C                   MOVEL     'Y2U0097'     ZAMSID
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      WZ = WZ + 1
     C                   ENDDO
 
     C                   EVAL      WNo = WNo + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EAPRSF    - Update DBF from subfile records.                 *
      *                                                               *
      *****************************************************************
     C     EAPRSF        BEGSR
 
      ** Initialise subfile reload flag.
 
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
 
      * Process all modified subfile records.
 
     C                   READC     #SFLRCD                                72
     C                   DOW       *IN72 = '0'
 
      * Process modified subfile record.
 
     C                   EXSR      EBPRSR
 
     C                   MOVEL     *BLANK        #1SEL
 
      ** Set screen conditioning indicators.
 
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                72
     C                   ENDDO
 
      ** If any errors, cancel reload.
 
     C                   IF        *IN79 = *ON
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EBPRSR    - Process modified subfile record.                 *
      *                                                               *
      *****************************************************************
     C     EBPRSR        BEGSR
 
      ** Set off error indicators.
 
     C                   MOVEA     WKIND0        *IN(32)
     C                   EVAL      *IN78 = *OFF
 
     C                   IF        W0PMD = 'ADD'
 
      ** Process add request.
 
     C                   IF        #1SEL <> 'D'
     C                   EXSR      DDNLRC
     C                   IF        W0NLR <> 'Y'
     C                   EXSR      ECADRQ
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        #1SEL = 'D'
 
      ** Process delete request.
 
     C                   EXSR      EDDLRQ
 
     C                   ELSE
 
      ** Process change request.
 
     C                   EXSR      EECHRQ
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If error occurred on update, note the fact.
 
     C                   IF        *IN78 = *ON
     C                   IF        *IN79 = *OFF
     C                   Z-ADD     ##RR          ##SFRC               79
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ECADRQ    - Process add request.                             *
      *                                                               *
      *****************************************************************
     C     ECADRQ        BEGSR
 
      ** USER: Create DBF record
      ** Create Message Type Descr - Message Type Descriptions
 
     C                   EXSR      SACRRC
 
     C                   IF        W0RTN <> *BLANK
 
      ** Write error detected.
 
     C                   MOVEA     WKIND1        *IN(32)
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN84 = *ON
     C                   ELSE
 
      ** DBF Write successful.
 
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EDDLRQ    - Process delete request.                          *
      *                                                               *
      *****************************************************************
     C     EDDLRQ        BEGSR
 
      ** USER: Delete DBF record
      ** Delete Message Type Descr - Message Type Descriptions  *
 
     C                   EXSR      SCDLRC
     C                   IF        W0RTN <> *BLANK
 
      ** Delete unsuccessful.
 
     C                   MOVEA     WKIND1        *IN(32)
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN84 = *ON
 
      ** If record altered, reset subfile record.
 
     C                   IF        W0RTN = 'Y2U0007'
     C                   EXSR      MBFL#1
     C                   ENDIF
 
     C                   ELSE
 
      ** DBF Delete successful.
      ** Blank out record and protect from entry.
 
     C                   EXSR      MAIZ#1
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN84 = *OFF
     C                   MOVEL     'Y'           W0RSF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EECHRQ    - Process update request.                          *
      *                                                               *
      *****************************************************************
     C     EECHRQ        BEGSR
 
      ** USER: Change DBF record
      ** Change Message Type Descriptions
 
     C                   EXSR      SECHRC
     C                   IF        W0RTN <> *BLANKS
 
      ** DBF Update error detected.
 
     C                   MOVEA     WKIND1        *IN(32)
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN84 = *ON
 
      ** Reset subfile record if changed record.
 
     C                   IF        W0RTN = 'Y2U0007'
     C                   EXSR      MBFL#1
     C                   ENDIF
 
     C                   ELSE
 
      ** DBF Update successful.
 
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FACHMD    - Flip between *ADD and *CHANGE modes.             *
      *                                                               *
      *****************************************************************
     C     FACHMD        BEGSR
 
     C                   IF        W0PMD <> 'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
     C                   EXSR      FBRQRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FBRQRL    - Request subfile reload.                          *
      *                                                               *
      *****************************************************************
     C     FBRQRL        BEGSR
 
     C                   MOVEL     'Y'           W0RSF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GADSA1    - Set display attributes for Subfile record.       *
      *                                                               *
      *****************************************************************
     C     GADSA1        BEGSR
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** Protect keys if change mode or updated record.
 
     C                   EVAL      *IN88 = *ON
 
     C                   IF        *IN89 = *ON AND *IN87 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN69 = *IN87
 
     C                   IF        W0PMD = @CN(06)
     C                   EVAL      *IN69 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GBDSA2    - Set display attributes for Subfile control.      *
      *                                                               *
      *****************************************************************
     C     GBDSA2        BEGSR
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIZ#1    - Initialise subfile record.                       *
      *                                                               *
      *****************************************************************
     C     MAIZ#1        BEGSR
 
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     *BLANK        #1MTPY
     C                   MOVEL     *BLANK        #1MTPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MBFL#1    - Move TIIMMSL1 fields to subfile.                 *
      *                                                               *
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   MOVEL     TIMSG         #1MTPY
     C                   MOVEL     TICOND        #1MTPD
     C                   MOVEL     @1DBRC        #1DBRC
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  MEIZ#2    - Initialise subfile control.                      *
      *                                                               *
      *****************************************************************
     C     MEIZ#2        BEGSR
 
     C                   MOVEL     *BLANK        #2MTPY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SACRRC    - Create Message Type Description                  *
      *                                                               *
      *****************************************************************
     C     SACRRC        BEGSR
 
     C                   MOVEL     *BLANK        W0RTN
 
      ** Move all fields to TIIMMSL0
 
     C                   MOVEL     #1MTPY        TIMSG
     C                   MOVEL     #1MTPD        TICOND
 
     C     KLCRSA        KLIST
     C                   KFLD                    TIMSG
 
      ** Check for duplicate primary key.
 
     C     KLCRSA        SETLL     TIIMMSD0                               70
     C                   IF        *IN70 = *ON
     C                   MOVEL     'USR1603'     W0RTN
 
      ** Send message 'Message Type Descripti EX'
 
     C                   MOVEL     'USR1603'     ZAMSID
     C                   EXSR      ZASNMS
     C                   LEAVESR
     C                   ENDIF
 
     C                   WRITE     TIIMMSD0                             71
 
     C                   IF        *IN71 = *ON
     C                   EVAL      W0RTN = 'Y2U0004'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCDLRC    - Delete Message Type Description                  *
      *                                                               *
      *****************************************************************
     C     SCDLRC        BEGSR
 
     C                   MOVEL     *BLANK        W0RTN
 
      ** Move key fields to TIIMMSL0
 
     C                   MOVEL     #1MTPY        TIMSG
 
     C     KLDLSC        KLIST
     C                   KFLD                    TIMSG
 
     C     KLDLSC        CHAIN     TIIMMSD0                           7071
 
     C                   IF        *IN70 = *ON
     C                   MOVEL     'Y2U0009'     W0RTN
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        *IN71 = *ON
 
      ** Record locked.
 
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   LEAVESR
     C                   ENDIF
 
      ** Check for changed record.
 
     C                   IF        #1DBRC <> @1DBRC
     C                   MOVEL     'Y2U0007'     W0RTN
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
     C     KLDLSC        SETLL     TIIMMSD0                           7071
     C                   LEAVESR
     C                   ENDIF
 
     C                   DELETE    TIIMMSD0                             71
 
     C                   IF        *IN71 = *ON
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SECHRC    - Change Message Type Description                  *
      *                                                               *
      *****************************************************************
     C     SECHRC        BEGSR
 
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1MTPY        TIMSG
 
     C     KLCHSE        KLIST
     C                   KFLD                    TIMSG
     C     KLCHSE        CHAIN     TIIMMSD0                           7071
 
     C                   IF        *IN70 = *ON
     C                   MOVEL     'Y2U0009'     W0RTN
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        *IN71 = *ON
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   LEAVESR
     C                   ENDIF
 
      ** Check for changed record.
 
     C                   IF        #1DBRC <> @1DBRC
     C                   MOVEL     'Y2U0007'     W0RTN
 
      ** Send message '*Update not accepted'
 
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'GBY2USRMSG'  ZAMSGF
     C                   EXSR      ZASNMS
 
      ** Use SETLL to release record lock.
 
     C     KLCHSE        SETLL     TIIMMSD0                           7071
     C                   LEAVESR
 
     C                   ENDIF
 
      ** Move Non-key fields to TIIMMSL0
 
     C                   MOVEL     #1MTPD        TICOND
 
     C                   UPDATE    TIIMMSD0                             71
     C                   IF        *IN71 = *ON
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS    - Send message to program's message queue.         *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   IF        ZAPGM = *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   ENDIF
 
      ** If no message file specified use default.
 
     C                   IF        ZAMSGF = *BLANK
     C                   MOVEL     ZADFMF        WMSGF
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      WMSGF         ZAMSGF
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      ** Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM
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
      *  ZHHPKY    - Display HELP text.                               *
      *                                                               *
      *****************************************************************
     C     ZHHPKY        BEGSR
 
     C                   MOVEL     'Y'           W0HLP
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB
     C                   PARM      *BLANK        YYHPFL
     C                   PARM      *BLANK        YYHPLB
     C                   PARM                    W0RTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZXEXPG    -                                                  *
      *                                                               *
      *****************************************************************
     C     ZXEXPG        BEGSR
 
     C                   EXSR      ZYEXPG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZYEXPG    - Exit program: Direct.                            *
      *                                                               *
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Terminate program.
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program.
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZZINIT    - Initialisation.                                  *
      *                                                               *
      *****************************************************************
     C     ZZINIT        BEGSR
 
     C                   MOVE      *BLANK        W0RTN
 
      ** Setup job date/time.
 
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
     C                   TIME                    ##TME
 
      ** Define work field Test ? in Key Field
 
     C                   MOVEL     *BLANK        WUTQKF
 
      ** Define work field If value in key field
 
     C                   MOVEL     *BLANK        WUIVKF
 
      ** Obtain default message file.
 
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF
     C                   IN        ZADFMF
 
      ** Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB
 
      ** Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC
 
      ** Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN
 
      ** Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01
 
      ** Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02
 
      ** Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03
 
      ** Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04
 
      ** Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05
 
      ** Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06
 
      ** Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07
 
      ** Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08
 
      ** Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09
 
      ** Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00
 
      ** Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11
 
      ** Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12
 
      ** Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM
 
      ** Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL
 
      ** Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT
 
      ** Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC
 
      ** Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF
 
      ** Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN
 
      ** Open files.
      ** Begin commit control.
 
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN
 
     C                   IF        W0RTN <> *BLANK AND W0RTN <> 'CPF8351'
     C                   EXSR      ZYEXPG
     C                   ENDIF
 
     C                   OPEN      TIIMMSL0
 
     C                   Z-ADD     14            ##SFPG            3 0
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         WRRMX
 
      ** If member empty, set to *ADD mode, else to *CHANGE mode.
 
     C                   IF        @1NROP = *ZERO
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
 
      ** Initialise subfile control.
 
     C                   EXSR      MEIZ#2
 
     C                   ENDSR
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
**CTDATA @CN
?
*
I
SDMTPYPD
A
ADD

     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Indicators by Loan Type/Subtype')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008120 - Stamp Tax Indicators by Loan Type/Sub Type        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR845644           Date 27Oct11               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR845644 - No validation rules when setting up Stamp         *
      *             Tax Indicator                                     *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FSD008120DFCF   E             WORKSTN
     F                                     SFILE(SD008120S1:RRN)
 
     FSDLOANL0  IF   E           K DISK
     FSDSTTPL0  UF A E           K DISK
 
     D ERDTA         E DS                  EXTNAME(CGERDTA)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
 
     D @STK            S             10    DIM(100)
     D @ERR            S             10    DIM(4) CTDATA PERRCD(1)
 
      ** Relative Record numbers
 
     D RRN             S              5  0
     D PRN             S              5  0
 
     D Q               S              5  0
     D PHAS            S              1
 
      ** Parameter variables
 
     D P@PGMQ          S             10
     D P@PGRL          S              5
     D P@MSGF          S             10
     D P@MSID          S              7
     D P@RTCD          S              7
     D P@OPTN          S              7
     D P@MSDA          S            132
     D P@MSTP          S              7
 
     D M#DTA           DS           256
 
      ** Message Data - Action field
 
     D  #MSGTX                 1     80
     D  ##MSGD                81    256
 
     D #MSGID          S              7
     D #MSGF           S             10
     D #MSGFL          S             10
     D #MSGDT          S            256
     D #MSGR           S              5
     D #MPGM           S             10
     D #MSGQ           S             10
     D #MSGT           S              7
 
     D W0KEY           S             30
     D W0ERNB          S              5  0
     D W0FILE          S             10
     D W0PREF          S             30
     D W0MSGD          S              7
     D W0MSGF          S             10
     D W0RTN           S              7
 
      ** Key Fields
 
     D KLKEY           S             10
     D KLTTYP          S              2
     D KLSTYP          S              2
 
      ** Program data structure
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      ** Rename filler field on LDA
      ** CRT001 changes mean that there is now a field ZZ019 on APOSTPD
      ** and associated PFs, which are held in a DS in some CG programs.
      ** The same field in two DS causes those programs to fail to
      ** compile - hence this version of ZZ019 is renamed.
 
     D  DBZZ19       E                     EXTFLD(ZZ019)
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    181 1830DBASE
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Main Processing
      *****************************************************************
 
      ** Program Initialisation
 
     C                   EXSR      INIT
 
      ** Do until F3 Pressed
 
     C                   DOW       *INKC = *OFF
 
     C                   IF        *IN70 = *OFF
     C                   IF        PHAS <> 'D'
 
     C                   IF        *IN50 = *OFF
     C                   WRITE     SD008120F1
     C                   ELSE
     C                   WRITE     SD008120F4
     C                   ENDIF
 
     C                   ELSE
     C                   WRITE     SD008120F3
     C                   ENDIF
 
     C                   ELSE
     C                   WRITE     SD008120F2
     C                   ENDIF
     C                   WRITE     SD008120C2
      *
     C                   IF        PHAS <> 'D'
 
     C                   IF        *IN11 = *OFF
     C                   WRITE     SD008120F5
     C                   ENDIF
 
     C                   EXFMT     SD008120C1
     C                   ELSE
     C                   WRITE     SD008120C1
     C                   EXFMT     SD008120F3
     C                   ENDIF
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         P@PGMQ
     C                   PARM      '*SAME'       P@PGRL
 
      ** Check for F3 (Exit)
 
     C                   IF        *INKC = *OFF
      *
     C                   IF        *IN70 = *OFF
     C                   IF        *IN11 = *ON
      *
     C                   SELECT
     C                   WHEN      PHAS  = 'A'
     C                   EXSR      AMDS
     C                   WHEN      PHAS  = 'D'
     C                   EXSR      DLTS
     C                   OTHER
     C                   EVAL      *IN88 = *OFF
     C                   EXSR      AMDDLT
     C                   ENDSL
     C                   ENDIF
     C                   ELSE
     C                   EXSR      ENTS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  INIT - Program Initialisation                                *
      *****************************************************************
     C     INIT          BEGSR
 
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C                   IF        *IN90   = '1' OR
     C                             P@RTCD <> *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN11
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *ON           *IN82
     C                   WRITE     SD008120C1
     C                   MOVE      *OFF          *IN82
 
     C                   MOVEL     'LOAN'        KLKEY
 
     C     KEYSTX        KLIST
     C                   KFLD                    KLKEY
     C                   KFLD                    KLTTYP
     C                   KFLD                    KLSTYP
 
     C                   Z-ADD     1             RRN
     C     *LOVAL        SETLL     SDLOANL0
     C                   READ      SDLOANL0                               99
     C                   DOW       *IN99 = *OFF
 
      ** Select only processing types that can have stamp tax
 
     C                   IF        AYLNPT = 61  OR
     C                             AYLNPT = 62  OR
     C                             AYLNPT = 63  OR
     C                             AYLNPT = 64  OR
     C                             AYLNPT = 65  OR
     C                             AYLNPT = 68  OR
     C                             AYLNPT = 70  OR
     C                             AYLNPT = 71  OR
     C                             AYLNPT = 80
 
     C                   MOVE      *BLANKS       #1OPT
     C                   MOVE      AYLNTY        KLTTYP
     C                   MOVE      AYLNST        KLSTYP
 
     C                   MOVE      AYLNTY        #1LNTY
     C                   MOVE      AYLNST        #1LNST
     C                   MOVE      AYLNTD        #1DESC
     C                   MOVE      *BLANKS       #1FTXF
     C                   MOVE      *BLANKS       #1CHGF
     C                   MOVE      *BLANKS       #1INTF
     C                   MOVE      *BLANKS       #1BALF
     C                   MOVE      AYLNTD        #1HDES
     C                   MOVE      AYLNTY        #1HTTP
     C                   MOVE      AYLNST        #1HSTP
     C                   MOVEL     'LOAN'        #1KEY
     C                   MOVEL     AYLNPT        #1HPRC                                     AR845644
 
     C     KEYSTX        CHAIN(E)  SDSTTPL0                           88
     C                   IF        *IN88  = *ON
     C                   ELSE
 
      ** Hidden fields
 
     C                   MOVE      LC1KEY        #1KEY
     C                   MOVE      LC1TFF        #1HTFF
     C                   MOVEL     LC1TFC        #1HTFC
     C                   MOVEL     LC1TFI        #1HTFI
     C                   MOVEL     LC1TFB        #1HTFB
 
      ** Subfile fields
 
     C                   MOVE      LC1TTP        #1LNTY
     C                   MOVE      LC1STP        #1LNST
     C                   MOVE      LC1TFF        #1FTXF
     C                   MOVEL     LC1TFC        #1CHGF
     C                   MOVEL     LC1TFI        #1INTF
     C                   MOVEL     LC1TFB        #1BALF
     C                   ENDIF
      *
     C                   MOVEA     '000'         *IN(40)
     C                   MOVEA     '000'         *IN(71)
     C                   MOVE      *ON           *IN11
      *
     C                   WRITE     SD008120S1
     C                   ADD       1             RRN
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      *
     C                   READ      SDLOANL0                               99
     C                   ENDDO
      *
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     1             #1SRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: All subroutines                                   *
      *                                                               *
      *  CALLS    : CGZERROR                                          *
      *                                                               *
      *  In the INIT sub-routine, the fields W0MSGD and W0MSGF should *
      *  be set to the default message I.D and message file that are  *
      *  used for the module. If not, the defaults of MEM5001 and     *
      *  MIDAS will be used.                                          *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
 
      ** Dump program
 
     C                   DUMP
 
      ** Set up the details of the message to be sent to MOPERQ
 
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
 
     C                   IF        Q   >  1  AND
     C                             Q   <  101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
 
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
 
      ** Get message for message code. If the msg code or the msg file
      ** have not been set up then use the defaults.
 
     C                   IF        W0MSGD =  *BLANKS
     C                   MOVEL     'MEM5001'     P@MSID
     C                   ELSE
     C                   MOVEL     W0MSGD        P@MSID
     C                   ENDIF
 
     C                   IF        W0MSGF =  *BLANKS
     C                   MOVEL     'MIDAS   '    P@MSGF
     C                   ELSE
     C                   MOVEL     W0MSGF        P@MSGF
     C                   ENDIF
 
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      P@MSID        #MSGID
     C                   PARM      P@MSGF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
 
     C                   MOVEL     #MSGTX        ERNARR
 
      ** Send message
 
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      ERDTA         #MSGDT
     C                   PARM      '*PRV '       #MSGR
     C                   PARM      '*'           #MPGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
 
      ** Fill LDA with error data
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
      ** Close down program
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN
 
      ** Provide a fuller report
 
     C                   MOVEA     @STK          #@STK           100
 
      ** End the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  AMDDLT - Check for Amended/Deleted Records                   *
      *****************************************************************
     C     AMDDLT        BEGSR
     C                   MOVE      *BLANKS       PHAS
 
     C                   READC     SD008120S1                             88
     C                   IF        *IN88 =  *OFF
     C                   IF        #1OPT =  'A'
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN72
     C                   UPDATE    SD008120S1
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN72
     C                   MOVE      'A'           PHAS
     C                   Z-ADD     RRN           PRN
     C                   Z-ADD     RRN           #1SRN
     C                   ENDIF
 
     C                   IF        #1OPT =  'D'
     C                   MOVE      'D'           PHAS
     C                   MOVE      *ON           *IN75
     C                   UPDATE    SD008120S1
     C                   MOVE      *OFF          *IN75
     C                   Z-ADD     RRN           PRN
     C                   Z-ADD     RRN           #1SRN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  AMDS - Process Amendment                                     *
      *****************************************************************
     C     AMDS          BEGSR
      *
     C                   MOVE      *ON           *IN50
     C     PRN           CHAIN     SD008120S1                         88
      *
     C                   IF        *IN88 =  *OFF
     C                   MOVEA     '00'          *IN(40)
     C                   MOVEA     '0000'        *IN(66)
     C                   MOVEA     '000'         *IN(72)
     C                   MOVE      *ON           *IN70
 
     C                   IF        *INKL =  *OFF
     C                   MOVE      #1LNTY        KLTTYP
     C                   MOVE      #1LNST        KLSTYP
      *
     C     KEYSTX        CHAIN     SDSTTPL0                           88
     C                   CLEAR                   LC1KEY
     C                   MOVEL     'LOAN'        LC1KEY
     C                   MOVE      #1LNTY        LC1TTP
     C                   MOVE      #1LNST        LC1STP
      *
     C                   IF        #1FTXF <>  'Y' AND
     C                             #1FTXF <>  'N' AND
     C                             #1FTXF <>  ' '
     C                   MOVE      *ON           *IN66
     C                   MOVEL     'USR9713'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   MOVEL     @ERR(1)       P@MSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        #1CHGF <>  'Y' AND
     C                             #1CHGF <>  'N' AND
     C                             #1CHGF <>  ' '
     C                   MOVE      *ON           *IN67
     C                   MOVEL     'USR9713'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   MOVEL     @ERR(2)       P@MSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        #1INTF <>  'Y' AND
     C                             #1INTF <>  'N' AND
     C                             #1INTF <>  ' '
     C                   MOVE      *ON           *IN68
     C                   MOVEL     'USR9713'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   MOVEL     @ERR(3)       P@MSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        #1BALF <>  'Y' AND
     C                             #1BALF <>  'N' AND
     C                             #1BALF <>  ' '
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'USR9713'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   MOVEL     @ERR(4)       P@MSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     AR845644
     C                   IF        #1HPRC = 61 OR                                           AR845644
     C                             #1HPRC = 68                                              AR845644
     C                   IF        #1FTXF = 'Y'                                             AR845644
     C                   MOVE      *ON           *IN66                                      AR845644
     C                   MOVEL     'USR9714'     P@MSID                                     AR845644
     C                   MOVEL     'SDUSRMSG'    P@MSGF                                     AR845644
     C                   MOVEL     @ERR(1)       P@MSDA                                     AR845644
     C                   EXSR      ZASNMS                                                   AR845644
     C                   ENDIF                                                              AR845644
     C                   ELSE                                                               AR845644
     C                   IF        #1BALF = 'Y'                                             AR845644
     C                   MOVE      *ON           *IN69                                      AR845644
     C                   MOVEL     'USR9715'     P@MSID                                     AR845644
     C                   MOVEL     'SDUSRMSG'    P@MSGF                                     AR845644
     C                   MOVEL     @ERR(4)       P@MSDA                                     AR845644
     C                   EXSR      ZASNMS                                                   AR845644
     C                   ENDIF                                                              AR845644
     C                   ENDIF                                                              AR845644
      *                                                                                     AR845644
      *
     C                   MOVE      #1FTXF        LC1TFF
     C                   MOVE      #1CHGF        LC1TFC
     C                   MOVE      #1INTF        LC1TFI
     C                   MOVE      #1BALF        LC1TFB
     C                   MOVE      BJRDNB        LC1LCD
     C                   MOVE      'I'           LC1CHT
     C                   MOVEL     ##USR         LC1USR
      *
     C                   IF        *IN66 = *OFF AND
     C                             *IN67 = *OFF AND
     C                             *IN68 = *OFF AND
     C                             *IN69 = *OFF
     C                   IF        *IN88 = *OFF
     C                   MOVE      'A'           LC1CHT
     C                   UPDATE    @LCSTT0
     C                   MOVEL     'USR9711'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   IF        #1FTXF = *BLANKS  AND
     C                             #1CHGF = *BLANKS  AND
     C                             #1INTF = *BLANKS  AND
     C                             #1BALF = *BLANKS
 
      ** Do not write if no input at all
 
     C                   ELSE
     C                   WRITE     @LCSTT0
     C                   MOVEL     'USR9712'     P@MSID
     C                   MOVEL     'SDUSRMSG'    P@MSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      #1HTFF        #1FTXF
     C                   MOVE      #1HTFC        #1CHGF
     C                   MOVE      #1HTFI        #1INTF
     C                   MOVE      #1HTFB        #1BALF
     C                   ENDIF
      *
     C                   IF        *IN66 = *OFF AND
     C                             *IN67 = *OFF AND
     C                             *IN68 = *OFF AND
     C                             *IN69 = *OFF
 
     C                   MOVE      *BLANKS       PHAS
     C                   MOVE      *BLANKS       #1OPT
 
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN77
     C                   ENDIF
 
     C                   UPDATE    SD008120S1
     C
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN77
     C                   MOVEA     '000'         *IN(40)
     C                   MOVEA     '00'          *IN(73)
     C                   MOVEA     '0000'        *IN(66)
     C                   ENDIF
 
     C                   MOVE      *OFF          *IN70
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  DLTS - Process Deletion                                      *
      *****************************************************************
     C     DLTS          BEGSR
 
     C     PRN           CHAIN     SD008120S1                         88
     C                   IF        *IN88 = *OFF
     C                   IF        *INKL = *OFF
     C                   MOVE      *ON           *IN75
     C                   MOVE      '*'           #1OPT
     C                   UPDATE    SD008120S1
     C                   MOVE      *OFF          *IN75
     C                   MOVE      #1LNTY        KLTTYP
     C                   MOVE      #1LNST        KLSTYP
     C     KEYSTX        CHAIN     SDSTTPL0                           88
     C                   IF        *IN88 = *OFF
     C                   DELETE    @LCSTT0
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       #1OPT
     C                   UPDATE    SD008120S1
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANKS       PHAS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ENTS - Process entered records                               *
      *****************************************************************
     C     ENTS          BEGSR
 
     C                   READC     SD008120S1                             98
     C                   DOW       *IN98 = *OFF
     C                   MOVEA     '000'         *IN(40)
     C                   MOVEA     '00'          *IN(73)
 
     C                   MOVE      #1CHGF        LC1TFC
     C                   MOVE      #1INTF        LC1TFI
     C                   MOVE      #1BALF        LC1TFB
     C                   MOVEL     'LOAN'        LC1KEY
     C                   MOVE      #1LNTY        LC1TTP
     C                   MOVE      #1LNST        LC1STP
     C                   MOVE      #1FTXF        LC1TFF
     C                   MOVE      #1CHGF        LC1TFC
     C                   MOVE      #1INTF        LC1TFI
     C                   MOVE      #1BALF        LC1TFB
     C                   MOVE      BJRDNB        LC1LCD
     C                   MOVE      'I'           LC1CHT
     C                   MOVEL     ##USR         LC1USR
     C                   WRITE     @LCSTT0
     C                   MOVE      *ON           *IN75
     C                   MOVE      '*'           #1OPT
 
     C                   UPDATE    SD008120S1
     C                   MOVE      *OFF          *IN75
 
     C                   READC     SD008120S1                             98
     C                   ENDDO
     C                   MOVE      *BLANKS       #1OPT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZASNMS - Send message to program's message queue             *
      *****************************************************************
     CSR   ZASNMS        BEGSR
 
     C                   IF        P@PGMQ  =  *BLANKS
     C                   MOVEL     ##PGM         P@PGMQ
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    P@PGMQ
     C                   PARM                    P@PGRL
     C                   PARM                    P@MSID
     C                   PARM                    P@MSGF
     C                   PARM                    P@MSDA
     C                   PARM                    P@MSTP
 
      ** Clear all fields for default mechanism next time
 
     C                   MOVEL     *BLANK        P@PGMQ
     C                   MOVEL     *BLANK        P@PGRL
     C                   MOVEL     *BLANK        P@MSID
     C                   MOVEL     *BLANK        P@MSGF
     C                   MOVEL     *BLANK        P@MSDA
     C                   MOVEL     *BLANK        P@MSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      ********************************************************************
     C/EJECT
      ********************************************************************
** CTDATA @ERR
principal
charge
interest
average

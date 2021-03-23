     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Pooling Accounts ICD maintenance')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ102*-*MIDAS*SD*ICD Account Balance Pooling*****************         EML110
      *  XXJ102 - MIDAS SD ICD Account Balance Pooling                *         EML110
      *                                                               *
      *  Function:  This program maintains the Account Balance        *
      *             Pooling ICD record.                               *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2005*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011I01          Date 25Apr08               *
      *                 TFJ011  (CHG001)   Date 21Jun05               *
      *                 TFJ011  *CREATE    Date 16Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011I01 - SFDC 250835 Account Pooling Screen Updates       *
      *              Inconsistent./Add Open/read/close on SDPICDV0 in *
      *              GETFDTLS routine.                                *
      *  TFJ011 - CHG001 Time validation wrong for batch number       *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
     F***SDJ102DF  CF   E             WORKSTN USROPN                            EML110
     FXXJ102DF  CF   E             WORKSTN USROPN                               EML110
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** DSP: Midas Account Pooling Installation Control Data Maintenance
      *
     F***SDPICDV0  UF A E           K DISK    USROPN                            EML110
     FXXPICDV0  UF A E           K DISK    USROPN                               EML110
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      ** RTV : Midas SD Pooling ICD Details
      *
      ********************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      /EJECT
      *
     D*****SDPFTPDA      E DS                  EXTNAME(SDPFTPDA)                EML110
     D XXPFTPDA      E DS                  EXTNAME(XXPFTPDA)                    EML110
      ** Data Area giving Installation Control Details
      *
     D*****GLPBTCHDA     E DS                  EXTNAME(GLPBTCHDA)               EML110
     D XXPBTCHDA     E DS                  EXTNAME(XXPBTCHDA)                   EML110
      ** Data Area Pooling Account Batch Number
      *
      ** Data structures:
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D**** SDPICD        E DS                  EXTNAME(SDPICDPP)                EML110
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    EML110
      ** Midas SD Pooling ICD Details
      *
     D SDTRAN        E DS                  EXTNAME(TABLETZ)
      ** Midas SD Transaction Types
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Midas SD Transaction Types
      *
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      ** Midas SD Department Codes
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank Details
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
     D TIM             S              4  0 DIM(20)
      *
      /EJECT
      ** Data structures:
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     D ZFieldN         DS
     D  HH#PITM                1      2S 0
     D  MM#PITM                3      4S 0
      *
      /EJECT
      *
      ** Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      /EJECT
      *
      ** Parameter declarations
     D P1PARM          DS            10
      ** KEY: Midas SD GCMS Interface ICD
      ** I : RST GCMS Interface ICD Key
     D  P1MODE                 1      1
     D P2PARM          DS
      ** O :  *Return code
     D  P2RTN                  1      7
     D P3PARM          DS
      ** B : MAP Work Return code
     D  P3WRTC                 1      5
     D                 DS
     D  ZAPGMQ         S             10
     D  ZAPGRL         S              5
     D  ZAMSID         S              7
     D  ZAMSGF         S             10
     D  ZAMSDA         S            132
     D  ZAMSTP         S              7
     D  TITLE          S              7
     D  PRTCD          S              7
     D  POPTN          S              7
     D  TimeVal        S              4
     D  WDigit         S              2  0
     D  ERR            S              1
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
     C     P2RTN         PARM      P2RTN         WP0001            7
     C     P3WRTC        PARM      P3WRTC        WP0002            5
      *****************************************************************
      ** Initialize
     C                   EXSR      ZZINIT
      *
      ** Perform once if all passed, else repeat
      ** Display and process key screen
     C
     C                   EXSR      BADSKY
     C
      ** Terminate program
     C                   EXSR      ZXEXPG
      *
      /EJECT
      *****************************************************************
     C     BADSKY        BEGSR
      *
      ** Display and process key screen
      *
     C     *IN30         DOUEQ     '1'
      *
      ** If error write messages
     C                   IF        ERR = 'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
     C                   WRITE     #RCDKEY
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
     C                   EXSR      CLEAR
      *
      ** Process response to screen
      ** Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   05              CAS                     RESET
     C   12              CAS                     ZYEXPG
      ** Process key screen input
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Clear message file
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     RESET         BEGSR
      *
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      ZZINIT
      *
      ** Reset all error indicators
      *
     C                   EXSR      CLRIND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     VALID         BEGSR
      *
     C                   IF        P1MODE = 'E'
     C                   EXSR      ZYEXPG
     C                   ENDIF
      *
      ** Clear error conditioning fields
      *
     C                   EVAL      P0RTN = *BLANKS
     C                   EVAL      ERR = 'N'
     C                   SETON                                        30
     C                   EXSR      CLRIND
      *
      ** Validate screen fields
      *
     C                   EXSR      PROCESS
      *
      ** Error detected?
      *
     C                   IF        ERR = 'Y'
     C                   SETOFF                                           30
     C                   ENDIF
      *
     C                   IF        *IN30 = '1'  AND
     C                             P1MODE = 'M'
     C                   EXSR      UPDAT
     C                   ENDIF
      *
      ** Reset global error indicator
     C                   SETOFF                                           99    *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     CLRIND        BEGSR
      *
     C                   SETOFF                                       313233
     C                   SETOFF                                       343536
     C                   SETOFF                                       373839
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   SETOFF                                       464748
     C                   SETOFF                                       495051
     C                   SETOFF                                       525354
     C                   SETOFF                                       555657
     C                   SETOFF                                       585960
     C                   SETOFF                                       616263
     C                   SETOFF                                       646566
     C                   SETOFF                                       676869
     C                   SETOFF                                       707172
     C                   SETOFF                                       737475
     C                   SETOFF                                       767778
     C                   SETOFF                                       798081
     C                   SETOFF                                       828384
     C                   SETOFF                                       8586
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     UPDAT         BEGSR
      *
      ** Move screen values to file
      *
     C                   IF        ERR = 'N' AND
     C                             *IN87 = '0'
      *
     C****************** OPEN      SDPICDV0                                     EML110
     C****************** READ      SDPICDV0                               91    EML110
     C                   OPEN      XXPICDV0                                     EML110
     C                   READ      XXPICDV0                               91    EML110
      *
     C                   EVAL      JIBRCH = SIBRCH
     C                   EVAL      JIFILE = SIFILE
     C                   EVAL      JPITM1 = SPITM1
     C                   EVAL      JPITM2 = SPITM2
     C                   EVAL      JPITM3 = SPITM3
     C                   EVAL      JPITM4 = SPITM4
     C                   EVAL      JPITM5 = SPITM5
     C                   EVAL      JPITM6 = SPITM6
     C                   EVAL      JPITM7 = SPITM7
     C                   EVAL      JPITM8 = SPITM8
     C                   EVAL      JPITM9 = SPITM9
     C                   EVAL      JPITM10 = SPITM10
     C                   EVAL      JPITM11 = SPITM11
     C                   EVAL      JPITM12 = SPITM12
     C                   EVAL      JPITM13 = SPITM13
     C                   EVAL      JPITM14 = SPITM14
     C                   EVAL      JPITM15 = SPITM15
     C                   EVAL      JPITM16 = SPITM16
     C                   EVAL      JPITM17 = SPITM17
     C                   EVAL      JPITM18 = SPITM18
     C                   EVAL      JPITM19 = SPITM19
     C                   EVAL      JPITM20 = SPITM20
     C                   EVAL      JOIAB = SOIAB
     C                   EVAL      JOTCAB = SOTCAB
     C                   EVAL      JOTFAB = SOTFAB
     C                   EVAL      JOTREC = SOTREC
     C                   EVAL      JOPCAB = SOPCAB
     C                   EVAL      JOPFAB = SOPFAB
     C                   EVAL      JOPREC = SOPREC
     C                   EVAL      JPOTM1 = SPOTM1
     C                   EVAL      JPOTM2 = SPOTM2
     C                   EVAL      JPOTM3 = SPOTM3
     C                   EVAL      JPOTM4 = SPOTM4
     C                   EVAL      JPOTM5 = SPOTM5
     C                   EVAL      JPOTM6 = SPOTM6
     C                   EVAL      JPOTM7 = SPOTM7
     C                   EVAL      JPOTM8 = SPOTM8
     C                   EVAL      JPOTM9 = SPOTM9
     C                   EVAL      JPOTM10 = SPOTM10
     C                   EVAL      JPOTM11 = SPOTM11
     C                   EVAL      JPOTM12 = SPOTM12
     C                   EVAL      JPOTM13 = SPOTM13
     C                   EVAL      JPOTM14 = SPOTM14
     C                   EVAL      JPOTM15 = SPOTM15
     C                   EVAL      JPOTM16 = SPOTM16
     C                   EVAL      JPOTM17 = SPOTM17
     C                   EVAL      JPOTM18 = SPOTM18
     C                   EVAL      JPOTM19 = SPOTM19
     C                   EVAL      JPOTM20 = SPOTM20
     C                   EVAL      JJTRNC = SJTRNC
     C                   EVAL      JJTRND = SJTRND
     C                   EVAL      JJDEPT = SJDEPT
     C                   EVAL      JJ1BNO = SJ1BNO
      *
     C                   IF        *IN91 = *ON
     C****************** WRITE     SDPICDD0                                     EML110
     C                   WRITE     XXPICDD0                                     EML110
     C                   ELSE
     C****************** UPDATE    SDPICDD0                                     EML110
     C                   UPDATE    XXPICDD0                                     EML110
     C                   ENDIF
     C****************** CLOSE     SDPICDV0                                     EML110
     C                   CLOSE     XXPICDV0                                     EML110
      *
     C**** *LOCK         IN        SDPFTPDA                                     EML110
     C     *LOCK         IN        XXPFTPDA                                     EML110
     C                   EVAL      JIP = SPSIP
     C                   EVAL      JUSER = SPSUS
     C                   EVAL      JPWORD = SPSPS
     C                   EVAL      JDIR = SPDIR
     C****************** OUT       SDPFTPDA                                     EML110
     C                   OUT       XXPFTPDA                                     EML110
      *
     C**** *LOCK         IN        GLPBTCHDA                                    EML110
     C     *LOCK         IN        XXPBTCHDA                                    EML110
     C                   EVAL      JBTCH = SJ1BNO
     C****************** OUT       GLPBTCHDA                                    EML110
     C                   OUT       XXPBTCHDA                                    EML110
      *
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     GETFDTLS      BEGSR
      *
      ***Move*SDPICDPP*fields*to*screen***********                              EML110
      ** Move XXPICDPP fields to screen                                         EML110
      *
     C****************** OPEN      SDPICDV0                                     TFJ011I01 EML110
     C****************** READ      SDPICDV0                               91    TFJ011I01 EML110
     C                   OPEN      XXPICDV0                                               EML110
     C                   READ      XXPICDV0                               91              EML110
     C                   EVAL      SIBRCH = JIBRCH
     C                   EVAL      SIFILE = JIFILE
     C                   EVAL      SPITM1 = JPITM1
     C                   EVAL      SPITM2 = JPITM2
     C                   EVAL      SPITM3 = JPITM3
     C                   EVAL      SPITM4 = JPITM4
     C                   EVAL      SPITM5 = JPITM5
     C                   EVAL      SPITM6 = JPITM6
     C                   EVAL      SPITM7 = JPITM7
     C                   EVAL      SPITM8 = JPITM8
     C                   EVAL      SPITM9 = JPITM9
     C                   EVAL      SPITM10 = JPITM10
     C                   EVAL      SPITM11 = JPITM11
     C                   EVAL      SPITM12 = JPITM12
     C                   EVAL      SPITM13 = JPITM13
     C                   EVAL      SPITM14 = JPITM14
     C                   EVAL      SPITM15 = JPITM15
     C                   EVAL      SPITM16 = JPITM16
     C                   EVAL      SPITM17 = JPITM17
     C                   EVAL      SPITM18 = JPITM18
     C                   EVAL      SPITM19 = JPITM19
     C                   EVAL      SPITM20 = JPITM20
     C                   EVAL      SOIAB = JOIAB
     C                   EVAL      SOTCAB = JOTCAB
     C                   EVAL      SOTFAB = JOTFAB
     C                   EVAL      SOTREC = JOTREC
     C                   EVAL      SOPCAB = JOPCAB
     C                   EVAL      SOPFAB = JOPFAB
     C                   EVAL      SOPREC = JOPREC
     C                   EVAL      SPOTM1 = JPOTM1
     C                   EVAL      SPOTM2 = JPOTM2
     C                   EVAL      SPOTM3 = JPOTM3
     C                   EVAL      SPOTM4 = JPOTM4
     C                   EVAL      SPOTM5 = JPOTM5
     C                   EVAL      SPOTM6 = JPOTM6
     C                   EVAL      SPOTM7 = JPOTM7
     C                   EVAL      SPOTM8 = JPOTM8
     C                   EVAL      SPOTM9 = JPOTM9
     C                   EVAL      SPOTM10 = JPOTM10
     C                   EVAL      SPOTM11 = JPOTM11
     C                   EVAL      SPOTM12 = JPOTM12
     C                   EVAL      SPOTM13 = JPOTM13
     C                   EVAL      SPOTM14 = JPOTM14
     C                   EVAL      SPOTM15 = JPOTM15
     C                   EVAL      SPOTM16 = JPOTM16
     C                   EVAL      SPOTM17 = JPOTM17
     C                   EVAL      SPOTM18 = JPOTM18
     C                   EVAL      SPOTM19 = JPOTM19
     C                   EVAL      SPOTM20 = JPOTM20
     C                   EVAL      SJTRNC = JJTRNC
     C                   EVAL      SJTRND = JJTRND
     C                   EVAL      SJDEPT = JJDEPT
     C                   EVAL      SJ1BNO = JJ1BNO
     C****************** CLOSE     SDPICDV0                                     TFJ011I01 EML110
     C                   CLOSE     XXPICDV0                                     EML110
     C                   ENDSR
      *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      ** Send message to program's message queue
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZXEXPG        BEGSR
      *
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     '**CMD**'     P2RTN                          *Return code
     C                   MOVEL     'CMD01'       P3WRTC                         Work Return cod
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
      *
     C****************** CLOSE     SDPICDV0                                     EML110
     C                   CLOSE     XXPICDV0                                     EML110
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZYEXPG        BEGSR
      *
     C****************** CLOSE     SDPICDV0                                     EML110
     C                   CLOSE     XXPICDV0                                     EML110
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZZINIT        BEGSR
      *
     C                   TIME                    ##TME
      ** Initialisation
      *
      ** Only do first time through
      *
     C                   IF        *IN01 = *OFF
      * Open files
     C****************** OPEN      SDJ102DF                                     EML110
     C                   OPEN      XXJ102DF                                     EML110
     C                   EVAL      ERR = 'N'
      *
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  ##PGM
     C                   OUT       LDA

     C**** *DTAARA       DEFINE                  SDPFTPDA                       EML110
     C**** *DTAARA       DEFINE                  GLPBTCHDA                      EML110
     C     *DTAARA       DEFINE                  XXPFTPDA                       EML110
     C     *DTAARA       DEFINE                  XXPBTCHDA                      EML110
      *  Get rundate
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      * Move rundate to display
     C                   MOVEL     BJMRDT        ##MRDT
      *
     C                   IF        P1MODE = 'E'
      * Protect input fields
     C                   SETON                                        87
     C****************** CALL      'AOPICDR0'                                   EML110
     C                   CALL      'XXPICDR0'                                   EML110
     C                   PARM      '        '    @RTCD
     C                   PARM      '*FIRST  '    POPTN
     C**** SDPICD        PARM      SDPICD        DSSDY                          EML110
     C     XXPICD        PARM      XXPICD        DSSDY                          EML110
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C****************** MOVEL     'SDPICDR0'    DBFILE                         EML110
     C                   MOVEL     'XXPICDR0'    DBFILE                         ************* EML110
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   ELSE
     C                   EXSR      GETFDTLS
     C                   ENDIF
      *
      ** Get details from data area
     C****************** IN        SDPFTPDA                                     EML110
     C                   IN        XXPFTPDA                                     EML110
     C                   EVAL      SPSIP = JIP
     C                   EVAL      SPSUS = JUSER
     C                   EVAL      SPSPS = JPWORD
     C                   EVAL      SPDIR = JDIR
      *
     C                   ENDIF
     C                   SETON                                        01
     C                   ENDIF
      *
      ** Read file on maintenance mode
     C                   IF        P1MODE = 'M'
      *
     C****************** CALL      'AOPICDR0'                                   EML110
     C                   CALL      'XXPICDR0'                                   EML110
     C                   PARM      '        '    @RTCD
     C                   PARM      '*FIRST  '    POPTN
     C**** SDPICD        PARM      SDPICD        DSSDY                          EML110
     C     XXPICD        PARM      XXPICD        DSSDY                          EML110
      *
     C                   IF        @RTCD = '       '
     C                   EXSR      GETFDTLS
     C                   ENDIF
      *
      ** Get details from data area
     C****************** IN        SDPFTPDA                                     EML110
     C                   IN        XXPFTPDA                                     EML110
     C                   EVAL      SPSIP = JIP
     C                   EVAL      SPSUS = JUSER
     C                   EVAL      SPSPS = JPWORD
     C                   EVAL      SPDIR = JDIR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     PROCESS       BEGSR
      *
      ** If there is an error in any of the fields then we need to
      ** redisplay the screen and send all error messages
      *
     C                   IF        *IN30 = '1'
      *
      ** Validate Internal Branch Code
      *
     C                   IF        SIBRCH = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1101'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        34
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *--------------------
      ** Validate FTP Incoming Default file name
      *
     C                   IF        SIFILE = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1102'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        35
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 1
      *
     C                   SETOFF                                       90
     C                   IF        SPITM1 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM1        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        3690
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM1
     C                   ENDIF
      *
     C                   ENDIF
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 2
      *
     C                   IF        SPITM2 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM2        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        3790
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM2
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 3
      *
     C                   IF        SPITM3 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM3        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        3890
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM3
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 4
      *
     C                   IF        SPITM4 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM4        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        3990
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM4
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 5
      *
     C                   IF        SPITM5 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM5        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4090
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM5
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 6
      *
     C                   IF        SPITM6 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM6        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4190
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM6
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 7
      *
     C                   IF        SPITM7 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM7        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4290
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM7
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 8
      *
     C                   IF        SPITM8 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM8        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4390
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM8
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 9
      *
     C                   IF        SPITM9 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM9        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4490
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM9
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 10
      *
     C                   IF        SPITM10 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM10       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4590
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM10
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 11
      *
     C                   IF        SPITM11 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM11       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4690
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM11
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 12
      *
     C                   IF        SPITM12 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM12       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4790
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM12
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 13
      *
     C                   IF        SPITM13 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM13       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4890
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM13
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 14
      *
     C                   IF        SPITM14 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM14       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        4990
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM14
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 15
      *
     C                   IF        SPITM15 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM15       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5090
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM15
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 16
      *
     C                   IF        SPITM16 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM16       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5190
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM16
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 17
      *
     C                   IF        SPITM17 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM17       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5290
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM17
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 18
      *
     C                   IF        SPITM18 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM18       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5390
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM18
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 19
      *
     C                   IF        SPITM19 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM19       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5490
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM19
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Incoming Intra-day FTP time 20
      *
     C                   IF        SPITM20 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPITM20       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        5590
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPITM20
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Move times to array
     C     *IN90         IFEQ      *OFF
     C                   MOVE      SPITM1        TIM(1)
     C                   MOVE      SPITM2        TIM(2)
     C                   MOVE      SPITM3        TIM(3)
     C                   MOVE      SPITM4        TIM(4)
     C                   MOVE      SPITM5        TIM(5)
     C                   MOVE      SPITM6        TIM(6)
     C                   MOVE      SPITM7        TIM(7)
     C                   MOVE      SPITM8        TIM(8)
     C                   MOVE      SPITM9        TIM(9)
     C                   MOVE      SPITM10       TIM(10)
     C                   MOVE      SPITM11       TIM(11)
     C                   MOVE      SPITM12       TIM(12)
     C                   MOVE      SPITM13       TIM(13)
     C                   MOVE      SPITM14       TIM(14)
     C                   MOVE      SPITM15       TIM(15)
     C                   MOVE      SPITM16       TIM(16)
     C                   MOVE      SPITM17       TIM(17)
     C                   MOVE      SPITM18       TIM(18)
     C                   MOVE      SPITM19       TIM(19)
     C                   MOVE      SPITM20       TIM(20)
      *
      * Validate to ensure that there are no embedded blank times
     C                   Z-ADD     1             X                 2 0
      *
      * If a time is blank keep reading until end, if another time is
      * found then error
     C     TIM(X)        DOWNE     0
     C                   ADD       1             X
     C     X             IFEQ      21
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C     X             DOWNE     21
      *
     C     TIM(X)        IFNE      0
     C                   EVAL      ZAMSID = 'XXX1116'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        903637
     C                   SETON                                        383940
     C                   SETON                                        414243
     C                   SETON                                        444546
     C                   SETON                                        474849
     C                   SETON                                        505152
     C                   SETON                                        535455
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Validate to ensure that times entered are in correct
      * ascending order
     C     *IN90         IFEQ      *OFF
      *
     C                   Z-ADD     2             X
     C                   Z-ADD     1             Y                 2 0
      *
     C     TIM(X)        DOWNE     0
      *
     C     TIM(X)        IFLE      TIM(Y)
     C                   EVAL      ZAMSID = 'XXX1117'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                          3637
     C                   SETON                                        383940
     C                   SETON                                        414243
     C                   SETON                                        444546
     C                   SETON                                        474849
     C                   SETON                                        505152
     C                   SETON                                        535455
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ADD       1             Y
      *
     C     X             IFEQ      21
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Today Intra-day A/C Bal
      *
     C                   IF        SOIAB = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1104'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        56
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *--------------------
      ** Validate FTP Outgoing Today COB A/C Bal
      *
     C                   IF        SOTCAB = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1105'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        57
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Today Final I-D A/C Bal
      *
     C                   IF        SOTFAB = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1106'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        58
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Today Reconcile Data
      *
     C                   IF        SOTREC = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1107'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        59
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Previous day Final I-d A/C Bal
      *
     C                   IF        SOPFAB = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1108'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        60
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Previous day COB A/C Bal
      *
     C                   IF        SOPCAB = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1109'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        61
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Previous day Reconcile data
      *
     C                   IF        SOPREC = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1110'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        62
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 1
     C                   SETOFF                                       90
      *
     C                   IF        SPOTM1 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM1        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6390
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM1
     C                   ENDIF
      *
     C                   ENDIF
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 2
      *
     C                   IF        SPOTM2 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM2        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6490
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM2
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 3
      *
     C                   IF        SPOTM3 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM3        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6590
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM3
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 4
      *
     C                   IF        SPOTM4 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM4        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6690
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM4
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 5
      *
     C                   IF        SPOTM5 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM5        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6790
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM5
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 6
      *
     C                   IF        SPOTM6 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM6        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6890
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM6
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 7
      *
     C                   IF        SPOTM7 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM7        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        6990
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM7
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 8
      *
     C                   IF        SPOTM8 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM8        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7090
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM8
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 9
      *
     C                   IF        SPOTM9 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM9        TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7190
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM9
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 10
      *
     C                   IF        SPOTM10 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM10       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7290
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM10
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 11
      *
     C                   IF        SPOTM11 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM11       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7390
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM11
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 12
      *
     C                   IF        SPOTM12 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM12       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7490
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM12
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 13
      *
     C                   IF        SPOTM13 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM13       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7590
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM13
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 14
      *
     C                   IF        SPOTM14 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM14       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7690
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM14
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 15
      *
     C                   IF        SPOTM15 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM15       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7790
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM15
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 16
      *
     C                   IF        SPOTM16 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM16       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7890
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM16
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 17
      *
     C                   IF        SPOTM17 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM17       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        7990
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM17
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 18
      *
     C                   IF        SPOTM18 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM18       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        8090
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM18
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 19
      *
     C                   IF        SPOTM19 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM19       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        8190
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM19
     C                   ENDIF
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate FTP Outgoing Intra-day FTP time 20
      *
     C                   IF        SPOTM20 <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 4
     C                   MOVE      SPOTM20       TimeVal
     C                   EXSR      NUMTST
     C                   IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1103'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        8290
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SPOTM20
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Move times to array
     C     *IN90         IFEQ      *OFF
     C                   MOVE      SPOTM1        TIM(1)
     C                   MOVE      SPOTM2        TIM(2)
     C                   MOVE      SPOTM3        TIM(3)
     C                   MOVE      SPOTM4        TIM(4)
     C                   MOVE      SPOTM5        TIM(5)
     C                   MOVE      SPOTM6        TIM(6)
     C                   MOVE      SPOTM7        TIM(7)
     C                   MOVE      SPOTM8        TIM(8)
     C                   MOVE      SPOTM9        TIM(9)
     C                   MOVE      SPOTM10       TIM(10)
     C                   MOVE      SPOTM11       TIM(11)
     C                   MOVE      SPOTM12       TIM(12)
     C                   MOVE      SPOTM13       TIM(13)
     C                   MOVE      SPOTM14       TIM(14)
     C                   MOVE      SPOTM15       TIM(15)
     C                   MOVE      SPOTM16       TIM(16)
     C                   MOVE      SPOTM17       TIM(17)
     C                   MOVE      SPOTM18       TIM(18)
     C                   MOVE      SPOTM19       TIM(19)
     C                   MOVE      SPOTM20       TIM(20)
      *
      * Validate to ensure that there are no embedded blank times
     C                   Z-ADD     1             X                 2 0
      *
      * If a time is blank keep reading until end, if another time is
      * found then error
     C     TIM(X)        DOWNE     0
     C                   ADD       1             X
     C     X             IFEQ      21
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C     X             DOWNE     21
      *
     C     TIM(X)        IFNE      0
     C                   EVAL      ZAMSID = 'XXX1116'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        906364
     C                   SETON                                        656667
     C                   SETON                                        686970
     C                   SETON                                        717273
     C                   SETON                                        747576
     C                   SETON                                        777879
     C                   SETON                                        808182
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Validate to ensure that times entered are in correct
      * ascending order
     C     *IN90         IFEQ      *OFF
      *
     C                   Z-ADD     2             X
     C                   Z-ADD     1             Y                 2 0
      *
     C     TIM(X)        DOWNE     0
      *
     C     TIM(X)        IFLE      TIM(Y)
     C                   EVAL      ZAMSID = 'XXX1117'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        906364
     C                   SETON                                        656667
     C                   SETON                                        686970
     C                   SETON                                        717273
     C                   SETON                                        747576
     C                   SETON                                        777879
     C                   SETON                                        808182
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ADD       1             Y
      *
     C     X             IFEQ      21
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      *--------------------
      ** Validate Journal Entries - Default Cr Transaction Type
      *
     C                   IF        SJTRNC <> *BLANKS
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       P@RTCD            7         B:Return code
     C                   PARM      '*KEY'        P@OPTN            7         I:Op7ion
     C     SJTRNC        PARM      SJTRNC        P@TRAT            5         I:Key field
     C     SDRETR        PARM      SDRETR        DSFDY                       O:Format
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      ZAMSID = 'XXX1111'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        83
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
      ** To be a valid Credit Transaction type, Debit/Credit Ind. must be = 'C'
     C                   IF        A1DCIN = 'C'
     C                   EVAL      SJTRNC = A1RTTY
     C                   ELSE
     C**                 EVAL      SJTRNC = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1114'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        83
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ZAMSID = 'XXX1111'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        83
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *--------------------
      ** Validate Journal Entries - Default Dr Transaction Type
      *
     C                   IF        SJTRND <> *BLANKS
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       P@RTCD            7         B:Return code
     C                   PARM      '*KEY'        P@OPTN            7         I:Op7ion
     C     SJTRND        PARM      SJTRND        P@TRAT            5         I:Key field
     C     SDRETR        PARM      SDRETR        DSFDY                       O:Format
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      ZAMSID = 'XXX1111'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        86
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
      ** To be a valid Debit Transaction type, Debit/Credit Ind. must be = 'D'
     C                   IF        A1DCIN = 'D'
     C                   EVAL      SJTRND = A1RTTY
     C                   ELSE
     C**                 EVAL      SJTRND = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1115'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        86
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ZAMSID = 'XXX1111'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        86
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *--------------------
      ** Validate Journal Entries - Default Default Department Code
      *
     C                   IF        SJDEPT <> *BLANKS
      *
     C                   CALL      'AODEPTR0'
     C                   PARM                    P@RTCD            7        B:Return code
     C                   PARM      '*VERIFY'     P@OPTN            7        I:Option
     C     SJDEPT        PARM      SJDEPT        P@DPCD            3        I:Dept. code
     C     SDDEPT        PARM      SDDEPT        DSFDY                      O:Format
      *
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      ZAMSID = 'XXX1112'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        84
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C
     C                   ELSE
     C                   EVAL      ZAMSID = 'XXX1112'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        84
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *--------------------
      ** Validate Journal Entries - First Batch Number
      *
     C                   IF        SJ1BNO <> *BLANKS
      *
     C                   EVAL      TimeVal = *BLANKS
     C                   EVAL      WDigit = 3
     C                   MOVE      SJ1BNO        TimeVal
     C*******************EXSR      NUMTST
     C                   CALL      'ZALIGN'                             92
     C                   PARM                    ReturnCode        1
     C                   PARM      TimeVal       ZField           16
     C                   PARM      0             Zadec             1 0
     C                   PARM      WDigit        Zadig             2 0
     C                   PARM      *BLANK        ZFieldOut        16
      *
     C     *IN92         IFEQ      '1'
     C     ReturnCode    ORNE      *BLANKS
      *
     C*******************IF        Numeric = 'N'
     C                   EVAL      ZAMSID = 'XXX1113'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        85
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   MOVE      ZFieldOut     SJ1BNO
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ZAMSID = 'XXX1113'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        85
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     NUMTST        BEGSR
      *
      * check if numeric
      *
     C                   CALL      'ZALIGN'                             92
     C                   PARM                    ReturnCode        1
     C                   PARM      TimeVal       ZField           16
     C                   PARM      0             Zadec             1 0
     C                   PARM      WDigit        Zadig             2 0
     C                   PARM      *BLANK        ZFieldOut        16
      *
     C     *IN92         IFEQ      '1'
     C     ReturnCode    ORNE      *BLANKS
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   MOVE      'N'           Numeric           1
     C                   ELSE
     C                   MOVE      'Y'           Numeric           1
     C                   MOVE      ZFieldOut     ZFieldN
     C                   ENDIF
      *
      * check if numeric in HHMM format
     C                   IF        Numeric = 'Y'
     C                   IF        HH#PITM < 0 OR HH#PITM > 23 OR
     C                             MM#PITM < 0 OR MM#PITM > 59
     C                   MOVE      'N'           Numeric
     C                   ELSE
     C                   MOVE      'Y'           Numeric
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
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

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2018

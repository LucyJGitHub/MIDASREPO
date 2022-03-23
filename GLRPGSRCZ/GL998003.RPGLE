     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Batches from APOUTPUTPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL998003 - Validate Batches from APOUTPUTPD                  *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059435 *CREATE   Date 16Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059435 - STP Batch entered Midas as held with an error     *
      *             in the header record                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         End of file                                     *
      *    LR         End of program                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * ACUM_PTAM     - Accumulate Posting Amount                     *
      * DET_DECPLCS   - Determine number of Decimal Places            *
      * DET_PTAM      - Validate Posting Amount                       *
      * GET_HEADER    - Get the Batch Header                          *
      * READ_POSTINGS - Read Posting                                  *
      * UPDT_GLBTCS   - Update Status                                 *
      * VAL_ACID      - Validate Account ID                           *
      * VAL_CYCD      - Validate Currency                             *
      * VAL_PTAM      - Determine Valid Posting Amount                *
      * WRT_BTCE      - Write to GLBTCEPD Batch Error file            *
      * *PSSR         - Error processing                              *
      * *INZSR        - Initialise                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FGLBTCSL0  UF   E           K DISK    INFSR(*PSSR)
     FGLBTCHPD  IF   E           K DISK    INFSR(*PSSR)
     FGLBTCPPD  IF   E           K DISK    INFSR(*PSSR) PREFIX(X)
     FGLBTCEL0  IF A E           K DISK    INFSR(*PSSR)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Work field for Account Identifier
     D #DDACID         DS            10
     D #ACF6                   1      6
     D #ACF3                   1      3
     D #ACF1                   1      1
     D #ACA1                   1      1
     D #ACA2                   2      2
     D #ACA3                   3      3
     D #ACM2                   4      5
     D #ACL5                   6     10
     D #ACL4                   7     10
     D                 DS
     D #INT15                  1     15  0
     D #INT14                  1     14  0
     D #INT13                  1     13  0
     D #INT12                  1     12  0
     D #INT01                 15     15  1
     D #INT02                 14     15  2
     D #INT03                 13     15  3
     D                 DS
     D #DEC09                  1      9  3
     D #DEC06                  1      6  0
     D #DEC03                  7      9  0
      *********************************************************************
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
      ** Read batches for today
      *
     C     GLBTCSK       SETLL     GLBTCSD0
     C     GLBTCSK       READE     GLBTCSD0                               99
     C                   DOW       *IN99=*off
      *
     C                   IF        STATUS <> 'F' and STATUS <> 'P'
      *
      ** Get batch header
      *
     C                   MOVEL     ' '           Batch_Hdr         1
     C                   EXSR      GET_HEADER
      *
      ** Read batch postings
      *
     C                   IF        Batch_Hdr = 'Y'
     C                   EXSR      READ_POSTINGS
     C                   ENDIF
      *
      ** Update Status record
      *
     C                   EXSR      UPDT_GLBTCS
      *
     C                   ENDIF
      *
     C     GLBTCSK       READE     GLBTCSD0                               99
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * UPDT_GLBTCS - Update Status                                   *
      *                                                               *
      *****************************************************************
     C     UPDT_GLBTCS   BEGSR
      *
      ** First time of processing
      *
     C                   IF        STATUS = ' '
     C                   EVAL      STATUS = '1'                                 1st time
     C                   ELSE
      *
      ** Second time of processing
      ** If there's no batch header or there are invalid items => 'failed'
      *
     C                   IF        Batch_Hdr <> 'Y' or
     C                             EXTHINI <> NUMVLIT
     C                   EVAL      STATUS = 'F'                                 Failed
     C                   ELSE
     C                   EVAL      STATUS = 'P'                                 Passed
     C                   ENDIF
     C                   ENDIF
      *
      ** Update status
      *
     C                   EXCEPT    STS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * GET_HEADER - Get the Batch Header                             *
      *                                                               *
      *****************************************************************
     C     GET_HEADER    BEGSR
      *
     C     GLBTCHK       CHAIN     GLBTCHD0                           99
     C                   IF        *IN99 = *OFF
     C                   MOVEL     'Y'           Batch_Hdr
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * READ_POSTINGS - Read Posting                                  *
      *                                                               *
      *****************************************************************
     C     READ_POSTINGS BEGSR
      *
      ** Zeroize batch totals
      *
     C                   EVAL      EXTHIIN = *zero
     C                   EVAL      EXTHDIN = *zero
     C                   EVAL      EXTHINI = *zero
     C                   EVAL      NUMVLIT = *zero
      *
     C     GLBTCPK       SETLL     GLBTCPD0
     C     GLBTCPK       READE     GLBTCPD0                               99
     C                   DOW       *IN99=*off
      *
      ** Increment number of items
      *
     C                   EVAL      EXTHINI += 1
      *
      ** Error(s) in item
      *
     C                   MOVEL     'Y'           Valid_Item        1
      *
      ** Determine posting amount
      *
     C                   Z-ADD     *ZERO         #PTAM            13 0
     C                   EXSR      DET_PTAM
      *
      ** If no errors(s) in item add 1 to number of valid items and
      ** accumulate posting amounts
      *
     C                   IF        Valid_Item = 'Y'
     C                   ADD       1             NUMVLIT
     C                   EXSR      ACUM_PTAM
     C                   ENDIF
      *
     C     GLBTCPK       READE     GLBTCPD0                               99
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * DET_PTAM - Validate Posting Amount                            *
      *                                                               *
      *****************************************************************
     C     DET_PTAM      BEGSR
      *
      ** If Account Id is not blank
      *
     C     XDDACID       IFNE      *BLANKS
     C                   EXSR      VAL_ACID
     C                   ELSE
     C                   EVAL      XERMSG = 'No account ID'
     C                   EXSR      WRT_BTCE
     C                   GOTO      E_DET_PTAM
     C                   ENDIF
      *
      ** Validate Currency.
      *
     C                   IF        Valid_Item = 'Y'
     C     XDDCYCD       IFNE      *BLANKS
     C                   EXSR      VAL_CYCD
     C                   ELSE
     C                   EVAL      XERMSG = 'Unknown currency'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
     C                   ENDIF
      *
      ** If amount is not blank, then validate posting amount
      *
     C                   IF        Valid_Item = 'Y'
     C     XDDPTAM       IFNE      *BLANKS
     C                   EXSR      VAL_PTAM
     C                   ELSE
     C                   EVAL      XERMSG = 'Posting amount blank'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate debit/credit indicator
      *
     C     XDDDCIN       IFNE      'C'
     C     XDDDCIN       ANDNE     'D'
     C                   EVAL      XERMSG = 'Bad debit/credit indicator'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
      *
     C     E_DET_PTAM    ENDSR
      *****************************************************************
      *                                                               *
      *  VAL_ACID - Validate Account ID                               *
      *                                                               *
      *****************************************************************
     C     VAL_ACID      BEGSR
      *
      ** Determine the type of the entry for account id
      *
     C                   MOVE      XDDACID       #DDACID
      *
      ** Check for retail account identifier.
      *
     C                   TESTN                   #DDACID              01
     C     *IN01         IFEQ      *ON
      *
      ** Get currency of retail account
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      XDDACID       PKACID           10
     C                   PARM      *BLANKS       PKCUST            6
     C                   PARM      *BLANKS       PKCYCD            3
     C                   PARM      *BLANKS       PKACCD           10
     C                   PARM      *BLANKS       PKACSN            2
     C                   PARM      *BLANKS       PKBRCD            3
     C     SDACCT        PARM      SDACCT        DSSDY
      *
      ** If OK
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     CCY           XDDCYCD
     C                   ELSE
     C                   EVAL      XERMSG = 'Invalid account ID'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
     C                   goto      E_VAL_ACID
     C                   ENDIF
      *
      ** Check for nostro.
      *
     C                   TESTN                   #ACM2                01
     C     *IN01         IFEQ      *ON
     C     #ACA1         ANDLT     '0'
     C     #ACA2         ANDLT     '0'
     C     #ACA3         ANDLT     '0'
     C     #ACF3         ANDNE     *BLANKS
     C     #ACL5         ANDEQ     *BLANKS
     C                   MOVEL     XDDACID       XDDCYCD
     C                   goto      E_VAL_ACID
     C                   ENDIF
      *
     C     E_VAL_ACID    ENDSR
      *****************************************************************
      *                                                               *
      *  VAL_CYCD - Validate Currency                                 *
      *                                                               *
      *****************************************************************
     C     VAL_CYCD      BEGSR
      *
      ** Verify if currency exists
      *
     C                   IF        XDDCYCD <> PKCCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      XDDCYCD       PKCCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      XERMSG = 'Bad currency'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VAL_PTAM - Determine Valid Posting Amount                    *
      *                                                               *
      *****************************************************************
     C     VAL_PTAM      BEGSR
      *
      ** Determine no. of decimals and no. of integers.
      *
     C                   EXSR      DET_DECPLCS
      *
     C                   MOVE(P)   XDDPTAM       ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZalignOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   MOVE      ZFIELD        #PTAM
      *
     C     ZalignOK      IFEQ      'N'
     C     #PTAM         ORLE      *ZERO
     C                   Z-ADD     *ZERO         #PTAM
     C                   EVAL      XERMSG = 'Posting amount invalid'
     C                   EXSR      WRT_BTCE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DET_DECPLCS - Determine number of Decimal Places             *
      *                                                               *
      *****************************************************************
     C     DET_DECPLCS   BEGSR
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    *ZERO
     C                   Z-ADD     *ZERO         ZADEC
     C                   Z-ADD     13            ZADIG
     C     A6NBDP        WHENEQ    1
     C                   Z-ADD     1             ZADEC
     C                   Z-ADD     12            ZADIG
     C     A6NBDP        WHENEQ    2
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     11            ZADIG
     C     A6NBDP        WHENEQ    3
     C                   Z-ADD     3             ZADEC
     C                   Z-ADD     10            ZADIG
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  WRT_BTCE - Write to GLBTCEPD Batch Error file                *
      *                                                               *
      *****************************************************************
     C     WRT_BTCE      BEGSR
      *
     C                   MOVEL     'N'           Valid_Item
     C     GLBTCEK       CHAIN     GLBTCED0                           99
     C   99              WRITE     GLBTCED0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ACUM_PTAM - Accumulate Posting Amount                        *
      *                                                               *
      *****************************************************************
     C     ACUM_PTAM     BEGSR
      *
     C                   Z-ADD     *ZERO         #INT15
     C                   Z-ADD     *ZERO         #DEC09
     C                   Z-ADD     *ZERO         #HASH
      *
     C                   Z-ADD     #PTAM         #INT15
     C                   MLLZO     '0'           #INT15
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    *ZERO
     C                   ADD       #INT15        #HASH
     C     A6NBDP        WHENEQ    1
     C                   ADD       #INT14        #HASH            15 0
     C                   ADD       #INT01        #DEC09
     C     A6NBDP        WHENEQ    2
     C                   ADD       #INT13        #HASH
     C                   ADD       #INT02        #DEC09
     C     A6NBDP        WHENEQ    3
     C                   ADD       #INT12        #HASH
     C                   ADD       #INT03        #DEC09
     C                   ENDSL
      *
      ** Previous decimal total
      *
     C                   Z-ADD     EXTHDIN       #INT15
      *
      ** Add hash decimal calculated to posting amount
      *
     C                   ADD       #INT03        #DEC09
      *
      ** Add the carry over to hash integer calculated
      *
     C                   ADD       #DEC06        #HASH
      *
      ** New integer and decimal total
      *
     C                   ADD       #HASH         EXTHIIN
     C                   Z-ADD     #DEC03        EXTHDIN
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      ' '           W#RUN             1
      *
      ** Key lists
      *
     C     GLBTCSK       KLIST
     C                   KFLD                    BJMRDT
      *
     C     GLBTCHK       KLIST
     C                   KFLD                    DDFOID
      *
     C     GLBTCPK       KLIST
     C                   KFLD                    DDBTNB
      *
     C     GLBTCEK       KLIST
     C                   KFLD                    BJMRDT
     C                   KFLD                    DDFOID
     C                   KFLD                    XDDBTNB
     C                   KFLD                    XDDBINB
      *
     C                   MOVEL     *blank        I#ERMS           50
     C                   ENDSR
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
     C     *PSSR         BEGSR
      *
     C                   IF        W#RUN = *blank
     C                   EVAL      W#RUN = 'Y'
     C                   DUMP
     C                   EVAL      I#RTCD = '*ERROR*'
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     OGLBTCSD0  E            STS
     O                       STATUS
     O                       EXTHIIN
     O                       EXTHDIN
     O                       EXTHINI
     O                       NUMVLIT

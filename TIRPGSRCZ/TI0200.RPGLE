     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Outgoing message processing')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  TI0200 - Trade Innovation Outgoing Message Processing        *
      *                                                               *
      *  Function:  This program reads SWIFT outgoing messages from   *
      *             the TI/SWIFT message workfile (MSTISOPD) and      *
      *             writes them to the Midas outgoing message         *
      *             files PF/MGOREFPD and PF/MGOMSGPD.                *
      *                                                               *
      *  This program permanently runs in batch during input cycle    *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. MD051359           Date 19Jun18               *
      *                 CSW218             Date 19Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 247160             Date 05Jul07               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243504             Date 18Jan07               *
      *                 235778             Date 18Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11679           Date 05Jul06               *
      *                 BUG8871            Date 24Oct05               *
      *                 235631             Date 07Sep05               *
      *                 BUG4832            Date 10Nov04               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213308             Date 06Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212173             Date 18Nov02               *
      *                 205236             Date  2May01               *
      * Midas Release 4.01 -------------------------------------------*
      *                 192473             Date 14Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186996             Date 25Jan00               *
      *                 186877             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 169804             Date 14Dec99               *
      *                 161185             Date 14Dec99               *
      *                 167727             Date 08Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 144804             Date 12Oct98               *
      *                 CTI001  *CREATE    Date  7JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  MD051359 - TI outgoing message processing of block 3 tag 119 *
      *             defaults to 'STP'                                 *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  247160 - Increase sequence number field to 999. TI swift     *
      *           messages cannot be transmitted to Midas because     *
      *           there were more than 98 swift messages created for  *
      *           one TI transaction. Apply part of fix 229235.       *
      *  243504 - Clear ALL MULT Structure before every message to    *
      *           prevent previous message corrupting the current.    *
      *  235778 - Increase the number of occurs for MULT to 1000      *
      *  BUG11679 - Additional Conversion of Customer Number to Alpha.*
      *  BUG8871 - Write Block 3 where it exists                      *
      *  235631 - Some fields are repeated on MT700.  Ensure that     *
      *           multiple data structure is cleared.                 *
      *           MT700 is truncated if the MFLD is blank.            *
      *  BUG4832 - Ensure check for tags always include position one. *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  213308 - Succeeding details of field 79 (Narrative) are lost *
      *           when column 4 or 5 of the subfield is a colon (:)   *
      *           because it is treated as a field tag. Need to also  *
      *           check if column 1 is a colon. Remove portion which  *
      *           writes to @@BT & @@BC arrays as this is done twice  *
      *           causing ARRAY OUT of range problem. Should only     *
      *           write once for each branch.                         *
      *  212173 - Output validation fields for MT103s                 *
      *  205236 - Use date fields from RUNDAT                         *
      *  192473 - Extra digit in TRNO, MTRN and field :20:.  Caused   *
      *           by non initialisation of @@MTRN field.              *
      *  186996 - MT202 cannot be released because field AMTS in      *
      *           MGOREFPD is wrong. Initialize @@VER to *BLANKS      *
      *           before setting up field 32A.                        *
      *  186877 - Field 20 should be formatted with the original TI   *
      *           reference (i.e. no 'TI' prefix or 'MSGnnn'          *
      *  CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD)  *
      *  169804 - MGOREFPD fields are wrongly changed when MGOREFL0   *
      *           is accessed.                                        *
      *  161185 - Increase the number of occurs for MULT to 500 and   *
      *           dump and continue to the next message if exceeded.  *
      *  167727 - Setup CIND and CINDV century flags.                 *
      *  144804 - Program locks SDSYTMPD during COB.                  *
      *         - Access of SDSYTMPD incorrect.                       *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
     F********************************************************************
     F*
     FMSTISOPD  IF   E             DISK
     FSDBRCHL0  IF   E           K DISK
     FMGOMSGPD  O    E             DISK
     F                                     COMMIT
     FMGOREFPD  O    E             DISK
     F                                     COMMIT
     FMGOREFL0  IF   E           K DISK
     F                                     RENAME(MGOREFD0:MGREFL0)
     F                                     PREFIX(L0)                           169804
     FTI0200AU  O    E             PRINTER
     F/COPY WNCPYSRC,TI0200F001
      ********************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *       30         field/subfield found on message
      *       31         Block 3 found on message                                            BUG8871
      *       98         on when date format is MMDDYY
      *       99         EOF MSTISOPD
      *       99         EOF SDBRCHL0
      *       99         chain into MGOREFL0 fails
      *       99         on when record read from MSTISOPD is header
      *       99         on if call to ZM0060 ended in error
      *       99         error writing to MGOREFPD
      *       99         error writing to MGOMSGPD
      *       U6         message length greater than 9999
      *       U6         message integrity is not OK
      *       U7U8       Database Error
     F********************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @@W             S              1    DIM(20)                              Work Array
     D***@@BC***         S              3    DIM(200)                           branches    MD055146
     D***@@BT***         S             11    DIM(200)                           branch TIDs MD055146
     D @@BC            S              3    DIM(999)                                         MD055146
     D @@BT            S             11    DIM(999)                                         MD055146
      *
     D ARR             DS
     D  @ARR                   1   9999
     D                                     DIM(9999)
      ** Data Structure for Message
      *
     D*MULT*******     DS                  OCCURS(180)                          161185
     D*MULT*****       DS                  OCCURS(500)                                 161185 235778
     D MULT            DS                  OCCURS(1000)                                       235778
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  CTRC                  56     57
      **  Multiple occurrence data structure for message
      *
     D @MTAG           DS                  OCCURS(5)
     D  COLON1                 1      1    INZ(':')
     D  FLDNO                  2      3
     D  TAG                    4      4
     D  COLON2                 5      5    INZ(':')
      **  Data structure constructing message field tag
      *
     D                 DS
     D  @FLD                   1    100
     D  @COL1                  1      1                                                       213308
     D  @TAG4                  1      4
     D  @TAG5                  1      5
     D  @COL4                  4      4
     D  @COL5                  5      5
     D  @DAT4A                 5     54
     D  @DAT5A                 6     55
     D  @DATB                 51    100
     D  @DAT4B                55    100
     D  @DAT5B                56    100
      **  DS to break up data record
      *
     D A8BTID          DS            12
     D  ADDR1B                 1      8
     D  BRAN1B                10     12
     D** Branch's TID address
     D*
     D @@CRLF          DS
     D  @@CR                   1      1
     D  @@LF                   2      2
      **  Carriage Return/Line Feed
      *
     D @@VER           DS
     D  @@SVDT                 1      6
     D  @@CCY                  7      9
     D  @@AMTS                10     26
      **  Field :32A: split for verification messages
      *
     D                 DS
     D  @@HEAD                 1     50
     D  @@NWSN                 7     18
     D  @@ADDR                 7     14
     D  @@BRAN                16     18
     D  @@MTPY                34     36
     D  @@MTP1                34     34
     D  @@NWDS1               37     44
     D  @@NWDS2               46     48
     D  @@MPRY                49     49
     D  @@DELC                50     50
      **  Message header
      *
     D/COPY WNCPYSRC,TI0200D001
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSYTM        E DS                  EXTNAME(SDSYTMPD)
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D PRTCD           S              7A                                                      CSW218
     D CSW218          S              1A                                                      CSW218
     D POSSTR          S              5  0                                                    CSW218
     D POSEND          S              5  0                                                    CSW218
     D POSLEN          S              5  0                                                    CSW218
      *                                                                                       CSW218
      /EJECT
      *****************************************************************
      *                                                               *
      *   MAIN - main processing                                      *
      *                                                               *
      *   Calls  INIT    Initial processing                           *
      *          CHKINT  Check integrity of message                   *
      *          FMTMSG  Format messages for output                   *
      *          OUTMSG  Output the message to the message file       *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      INIT
      *
      ** Read from the messages workfile
      *
     C                   READ      MSTISOD0                               99    *
      *
      ** Initialize message array and set array pointer to 1
      *
     C                   MOVEL     *BLANK        @ARR
     C                   Z-ADD     1             @                 5 0
      *
      * Do while not end of file on messages workfile
      *
     C     *IN99         DOWNE     '1'
      *
      * If a basic header record has been read in
      ** Check the integrity of the message
      ** If it is OK
      **   Format the message for output
      **   then output the message to the message files
      *  Initialise the message array and set the array pointer to 1
      *
     C     '{1:'         SCAN      DATA                                   99    *
     C     *IN99         IFEQ      '1'
     C                   EXSR      CHKINT
     C/COPY WNCPYSRC,TI0200C004
     C     @@MSOK        IFEQ      'Y'
     C/COPY WNCPYSRC,TI0200C005
     C                   EXSR      FMTMSG
     C                   EXSR      OUTMSG
     C/COPY WNCPYSRC,TI0200C006
     C                   ENDIF
     C                   MOVEL     *BLANK        @ARR
     C                   Z-ADD     1             @
     C                   ENDIF
      *
      * Move data from record just read in into array
      * from a position in the array defined by the array pointer
      *
     C                   MOVEA     DATA          @ARR(@)
      *
      * increment the array pointer by 128
      *
     C                   ADD       128           @
      *
      * If message length greater than 9999, ignore this message
      * by initialising the message array and setting the pointer to 1
      *
     C     @             IFGT      9999
     C                   SETON                                        U6
     C                   DUMP
     C                   MOVEL     *BLANK        @ARR
     C                   Z-ADD     1             @
     C                   ENDIF
      *
      * Read from the messages workfile
      *
     C                   READ      MSTISOD0                               99    *
     C                   ENDDO
      *
      ** After EOF reached in the messages workfile
      ** Check the integrity of the message
      ** If it is OK
      **   Format the message for output
      **   then output the message to the message files
      *
     C                   EXSR      CHKINT
     C/COPY WNCPYSRC,TI0200C007
     C     @@MSOK        IFEQ      'Y'
     C/COPY WNCPYSRC,TI0200C008
     C                   EXSR      FMTMSG
     C                   EXSR      OUTMSG
     C/COPY WNCPYSRC,TI0200C009
     C                   ENDIF
      *
      ** End the program
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   CHKINT - Check Integrity of Message                         *
      *                                                               *
      *   Called by MAIN   Main processing                            *
      *   Calls     none                                              *
      *                                                               *
      *****************************************************************
     C     CHKINT        BEGSR
      *
     C                   MOVEL     'Y'           @@MSOK            1
      *
      ** No basic header or in the wrong place (should be in pos. 2)
      *
     C     '{1:'         SCAN      ARR           H                        99    *
     C     *IN99         IFNE      '1'
     C     H             ORNE      2
     C                   MOVEL     'N'           @@MSOK
     C                   ENDIF
      *
      ** No application header or in the wrong place (should be in pos. 31)
      *
     C     '{2:'         SCAN      ARR           H                        99    *
     C     *IN99         IFNE      '1'
     C     H             ORNE      31
     C                   MOVEL     'N'           @@MSOK
     C                   ENDIF
      *
      ** No text block
      *
     C     '{4:'         SCAN      ARR                                    99    *
     C     *IN99         IFNE      '1'
     C                   MOVEL     'N'           @@MSOK
     C                   ENDIF
      *
      ** No field :20:
      *
     C     ':20:'        SCAN      ARR                                    99    *
     C     *IN99         IFNE      '1'
     C                   MOVEL     'N'           @@MSOK
     C                   ENDIF
      *
      * If message not OK report an error but continue processing
      * (As the message is not OK it will be bypassed)
      *
     C     @@MSOK        IFNE      'Y'
     C     ARR           ANDNE     *BLANK
     C                   SETON                                        U6
     C                   DUMP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   FMTMSG - Format Messages for Output                         *
      *                                                               *
      *   Called by MAIN   Main processing                            *
      *   Calls     CLRMOD Clear multiple occurrence data structure   *
      *             *PSSR  Error handling                             *
      *                                                               *
      *****************************************************************
     C     FMTMSG        BEGSR
      *
      ** Retrieve the header information.
      *
      ** i.e. Senders address      @@NWSN
      **      Message Type         @@MTPY
      **      Destination Address1 @@NWDS1
      **      Destination Address2 @@NWDS2
      **      Message Priority     @@MPRY
      **      Delivery Monitoring  @@DELC
      *
     C                   MOVEA     @ARR(2)       @@HEAD
      *
      ** If a this is a payment message (MT202, MT203, MT100),
      ** the value date, currency and amount fields must be output
      ** to the file, so that, if the payment verification flag
      ** is on, the messages can be released.
      *
     C     @@MTPY        IFEQ      '100'
     C     @@MTPY        OREQ      '202'
     C     @@MTPY        OREQ      '203'
     C     @@MTPY        OREQ      '103'                                                      212173
      *
      ** Scan the array for field :32A:
      *
     C                   MOVE      *BLANKS       @@VER                          186996
     C     ':32A:'       SCAN      ARR           I
     C     I             ADD       5             I
     C     @@CRLF        SCAN      ARR:I         S
     C     S             SUB       I             @@LEN             5 0
     C     @@LEN         SUBST     ARR:I         @@VER
     C                   ENDIF
      *
      ** Get the Midas transaction number from field :20:
      *
     C     ':20:'        SCAN      ARR           H
     C                   ADD       4             H
     C     @@CRLF        SCAN      ARR:H         S
     C     S             SUB       H             @@LEN
     C                   MOVE      *BLANKS       @@MTRN                                       192473
     C     @@LEN         SUBST     ARR:H         @@MTRN           15
      *
      ** Set up the transaction number
      *
     C                   MOVEA     'TI'          @@W
     C                   MOVEA     @@MTRN        @@W(3)
     C**********         Z-ADD     *ZERO         @@SQN             2 0                        247160
     C                   Z-ADD     *ZERO         @@SQN             3 0                        247160
      *
      **  Check on MGOREFPD for a unique transaction number
      *
     C     *IN99         DOUEQ     '1'
     C*****@@SQN         OREQ      99                                                         247160
     C     @@SQN         OREQ      999                                                        247160
     C                   ADD       1             @@SQN
     C**********         MOVE      @@SQN         @@SEQ             2                          247160
     C**********         MOVEA     @@SEQ         @@W(15)                                      247160
     C                   MOVE      @@SQN         @@SEQ             3                          247160
     C                   MOVEA     @@SEQ         @@W(14)                                      247160
     C                   MOVEA     @@W           @@TRNO           16
     C     @@TRNO        CHAIN     MGREFL0                            99        *
     C                   ENDDO
      *
      ** If no more records can be added, flag this message as in error.
      *
     C*****@@SQN         IFEQ      99                                                         247160
     C     @@SQN         IFEQ      999                                                        247160
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     008           DBASE                          ***************
     C                   MOVEL     'MGREFL0 '    DBFILE                         *DB ERROR 008 *
     C                   MOVEL     '99      '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Check for Block 3                                                                   BUG8871
     C     '{3:'         SCAN      ARR           H                        31                 BUG8871
      *  Now process the text block (the actual message content)
      *
     C     '{4:'         SCAN      ARR           H
      *
      * Clear the multiple occurence data structure
      *
     C                   EXSR      CLRMOD
      *                                                                                      BUG8871
      **  If Block 3 present                                                                 BUG8871
      *                                                                                      BUG8871
     C     *IN31         IFEQ      '1'                                                       BUG8871
     C     '{119:'       SCAN      ARR           POSSTR                                     MD051359
     C                   IF        POSSTR <> 0                                              MD051359
     C     POSSTR        ADD       5             POSSTR                                     MD051359
     C     '}'           SCAN      ARR:POSSTR    POSEND                                     MD051359
     C     POSEND        SUB       POSSTR        POSLEN                                     MD051359
     C                   MOVEL     @@CRLF        CTRC                                        BUG8871
     C                   MOVEL     ':119:'       MTAG                                        BUG8871
     C                   MOVE      *BLANKS       MFLD                                        BUG8871
     C**********         MOVEL     'STP'         MFLD                               BUG8871 MD051359
     C                   EVAL      MFLD = %SUBST(ARR:POSSTR:POSLEN)                         MD051359
      *                                                                                      BUG8871
     C                   ADD       1             X                                           BUG8871
     C     X             OCCUR     MULT                                                      BUG8871
     C                   EVAL      POSSTR = *ZERO                                           MD051359
     C                   EVAL      POSEND = *ZERO                                           MD051359
     C                   EVAL      POSLEN = *ZERO                                           MD051359
     C                   ENDIF                                                              MD051359
      *                                                                                       CSW218
     C                   IF        CSW218 = 'Y'                                               CSW218
      *                                                                                       CSW218
     C     '{121:'       SCAN      ARR           POSSTR                                       CSW218
     C                   IF        POSSTR <> 0                                                CSW218
     C     POSSTR        ADD       5             POSSTR                                       CSW218
     C                   MOVEL     @@CRLF        CTRC                                         CSW218
     C     '}'           SCAN      ARR:POSSTR    POSEND                                       CSW218
     C     POSEND        SUB       POSSTR        POSLEN                                       CSW218
     C                   MOVEL     ':121:'       MTAG                                         CSW218
     C                   MOVE      *BLANKS       MFLD                                         CSW218
     C                   EVAL      MFLD = %SUBST(ARR:POSSTR:POSLEN)                           CSW218
     C                   ADD       1             X                                            CSW218
     C     X             OCCUR     MULT                                                       CSW218
     C                   EVAL      POSSTR = *ZERO                                             CSW218
     C                   EVAL      POSEND = *ZERO                                             CSW218
     C                   EVAL      POSLEN = *ZERO                                             CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
     C                   ENDIF                                                               BUG8871
      *
      **  For all fields/subfields
      *
     C     *IN30         DOUEQ     '0'
      *
      ** Extract field details
      *
     C     @@CRLF        SCAN      ARR:H         H
     C     H             ADD       2             S                 5 0
     C     @@CRLF        SCAN      ARR:S         H                        30    *
     C     H             SUB       S             @@LEN             5 0
      *
      ** If field/subfield found...
      *
     C     *IN30         IFEQ      '1'
      *
      ** Extract field details
      *
     C                   MOVE      @@CRLF        CTRC
     C                   MOVE      *BLANKS       @FLD
     C     @@LEN         SUBST     ARR:S         @FLD
      *
     C                   MOVEL     'N'           @@MORE            1
      *
      ** Format details
      *
     C     @COL5         IFEQ      ':'
     C     @COL1         ANDEQ     ':'                                                        213308
     C     @DAT5B        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       CTRC
     C                   MOVEL     'Y'           @@MORE
     C                   ENDIF
     C                   MOVEL     @TAG5         MTAG
     C                   MOVEL     @DAT5A        MFLD
     C                   ELSE
     C     @COL4         IFEQ      ':'
     C     @COL1         ANDEQ     ':'                                                        213308
     C     @DAT4B        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       CTRC
     C                   MOVEL     'Y'           @@MORE
     C                   ENDIF
     C                   MOVEL     @TAG4         MTAG
     C                   MOVEL     @DAT4A        MFLD
     C                   ELSE
     C     @DATB         IFNE      *BLANKS
     C                   MOVEL     *BLANKS       CTRC
     C                   MOVEL     'Y'           @@MORE
     C                   ENDIF
     C                   MOVEL     *BLANKS       MTAG
     C                   MOVEL     @FLD          MFLD
     C                   ENDIF
     C                   ENDIF
      *
     C     MTAG          IFEQ      ':20: '
     C                   MOVE      *BLANKS       MFLD
     C*******************MOVEL     @@TRNO        MFLD                           186877
     C                   MOVEL     @@MTRN        MFLD                           186877
     C                   ENDIF
      *
     C                   ADD       1             X
      *                                                                         161185
     C                   IF        X > 500                                      161185
     C                   SETON                                        U6        161185
     C                   DUMP                                                   161185
     C                   LEAVE                                                  161185
     C                   ENDIF                                                  161185
      *                                                                         161185
     C     X             OCCUR     MULT
      *
      ** Process additional data over 50 characters
      *
     C     @@MORE        IFEQ      'Y'
      *
      ** Move remaining details to DS entry for next record
      *
     C                   SELECT
     C     @COL4         WHENEQ    ':'
     C     @COL1         ANDEQ     ':'                                                       BUG4832
     C                   MOVEL(P)  @DAT4B        MFLD
     C     @COL5         WHENEQ    ':'
     C     @COL1         ANDEQ     ':'                                                       BUG4832
     C                   MOVEL(P)  @DAT5B        MFLD
     C                   OTHER
     C                   MOVEL(P)  @DATB         MFLD
     C                   ENDSL
      *
      ** Clear tag field and set CrLf
      *
     C                   CLEAR                   MTAG
     C                   MOVEL     @@CRLF        CTRC
      *
      ** Increment index to next data structure occurence
      *
     C                   ADD       1             X
      *                                                                         161185
     C                   IF        X > 500                                      161185
     C                   SETON                                        U6        161185
     C                   DUMP                                                   161185
     C                   LEAVE                                                  161185
     C                   ENDIF                                                  161185
      *                                                                         161185
     C     X             OCCUR     MULT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     X             X#LAST                                       235631
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   OUTMSG - Output the message to the message files            *
      *                                                               *
      *   Called by MAIN   Main processing                            *
      *   Calls     WRTREF Write a record to PF/MGOREFPD              *
      *             *PSSR  Error handling                             *
      *                                                               *
      *****************************************************************
      *
     C     OUTMSG        BEGSR
      *
      **  Write reference record to PF/MGOREFPD.
      *
     C                   EXSR      WRTREF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
      *
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
      *
     C*****X*****        DOWLE     180                                          161185
     C     X             DOWLE     500                                          161185
     C*****MFLD**        ANDNE     *BLANKS                                                    235631
     C     X             ANDLT     X#LAST                                                     235631
      *
     C                   WRITE     MGOMSGD0                             99
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE                          ***************
     C                   MOVEL     'MGOMSGPD'    DBFILE                         *DB ERROR 006 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO
      *
      **  COMIT all changes since no error on writing the message
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   WRTREF - Write record to PF/MGOREFPD                        *
      *                                                               *
      *   Called by OUTMSG Output the message to the message file     *
      *   Calls     DETBRC Determine branch from sender's address     *
      *             *PSSR  Error handling                             *
      *                                                               *
      *****************************************************************
      *
     C     WRTREF        BEGSR
      *
      ** Set up the record to go to PF/MGOREFPD
      *
     C                   MOVEL     'TI '         SYTM
     C                   MOVEL     'TI'          MODI
     C                   MOVE      @@TRNO        TRNO
     C                   MOVE      *BLANKS       TRNF
     C                   MOVE      *BLANKS       TRNM
     C                   MOVEL     @@MTRN        MTRN
     C                   MOVE      'XX'          TNTP
     C     @@MTP1        IFEQ      '4'
     C                   MOVE      'CO'          TNTP                           * COLLECTIONS
     C                   ENDIF
     C     @@MTP1        IFEQ      '7'
     C                   MOVE      'DC'          TNTP                           * DOC CREDITS
     C                   ENDIF
     C                   MOVE      *BLANKS       SBTP
     C                   MOVE      *BLANKS       EVTP
     C                   MOVEL     'SWIFT'       NWRK
     C**********         Z-ADD     *ZERO         SECN                                       BUG11679
     C                   MOVE      *BLANKS       SECN                                       BUG11679
     C                   MOVEL     @@NWSN        NWSN
     C**********         Z-ADD     *ZERO         DECN                                       BUG11679
     C                   MOVE      *BLANKS       DECN                                       BUG11679
     C                   MOVEL     @@NWDS1       W#NWDS           11
     C                   MOVE      @@NWDS2       W#NWDS
     C                   MOVEL(p)  W#NWDS        NWDS
     C                   MOVEL     *BLANKS       NWBN
     C                   MOVE      @@MTPY        MTPY
     C                   MOVE      @@MPRY        MPRY
      *
      ** Set up the message status from the default status field
      *
     C                   MOVE      ECDFST        MGST
     C     MGST          IFEQ      'CRTD'
     C                   MOVE      '1'           MGSG
     C                   ENDIF
     C     MGST          IFEQ      'RSND'
     C                   MOVE      '2'           MGSG
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       LSCC
     C                   MOVEL     *BLANKS       F57U
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
     C                   MOVEL     @@HRDT        HRDT
     C                   MOVE      @@MGDE        MGDE
     C                   TIME                    MGTM
     C**********         MOVE      BJMRDT        LADT                                         205236
     C                   MOVE      AGMRDT        LADT                                         205236
     C                   MOVE      MGTM          LATM
     C                   MOVEL     *BLANK        RELD
     C                   Z-ADD     *ZERO         RELT
     C                   MOVEL     *BLANK        RUSR
     C                   MOVEL     *BLANK        RWSN
     C                   MOVEL     *BLANKS       AMTX
     C                   MOVEL     *BLANKS       AMTS
     C                   MOVEL     *BLANKS       SVDT
     C                   MOVEL     *BLANKS       CCY
      *
      ** If this is an MT202, MT203 or an MT100, output the payment
      ** verification fields.
      *
     C     @@MTPY        IFEQ      '100'
     C     @@MTPY        OREQ      '202'
     C     @@MTPY        OREQ      '203'
     C     @@MTPY        OREQ      '103'                                                      212173
     C                   MOVEL     @@AMTS        AMTS
     C                   MOVEL     @@SVDT        SVDT
     C                   MOVEL     @@CCY         CCY
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       NSNO
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       AORR
     C                   MOVEL     *BLANKS       DESI
      *
      ** Determine branch by looking for the senders address
      ** in each branch's TID address
      *
     C                   EXSR      DETBRC
     C                   MOVE      @@BRCA        BRCA
     C                   MOVEL     *BLANKS       OTHB
     C                   MOVEL     *BLANKS       RCBR
     C                   MOVEL     *BLANKS       OTHT
     C                   MOVE      *BLANKS       NETI
     C     @@DELC        IFEQ      '}'
     C                   MOVE      *BLANKS       DELC
     C                   ELSE
     C                   MOVE      @@DELC        DELC
     C                   ENDIF
     C                   MOVE      *BLANKS       DYST
     C                   MOVE      *BLANKS       RSID
     C                   MOVE      *BLANKS       MSE1
     C                   MOVE      *BLANKS       ELIN
     C                   MOVE      *BLANKS       SSAC
     C                   MOVE      *BLANKS       MIR
      *
      ** If this is an MT202, Testkey Status must be set to 'Y'
      *
     C     @@MTPY        IFEQ      '202'
     C     @@MTPY        OREQ      '203'
     C     @@MTPY        OREQ      '100'
     C     @@MTPY        OREQ      '103'                                                      212173
     C                   MOVE      'Y'           TSKS
     C                   ELSE
     C                   MOVEL     *BLANKS       TSKS
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       TSKY
     C                   Z-ADD     *ZERO         TSEQ
     C                   MOVE      *BLANKS       CFPF
     C                   Z-ADD     *ZERO         PT210
     C                   Z-ADD     *ZERO         AVDT
     C                   Z-ADD     *ZERO         ASEQ
     C                   MOVE      *BLANKS       TODY
      *                                                                         167727
      ** Set-up Message Generation Century flag                                 167727
      *                                                                         167727
     C                   MOVEL     MGDE          YY                2 0          167727
     C     YY            IFLT      72                                           167727
     C                   MOVE      '2'           CIND                           167727
     C                   ELSE                                                   167727
     C                   MOVE      '1'           CIND                           167727
     C                   ENDIF                                                  167727
      *                                                                         167727
      ** Setup century indicator CINDV for value date SVDT                      167727
      *                                                                         167727
     C     SVDT          IFEQ      *BLANK                                       167727
     C                   MOVE      *BLANK        CINDV                          167727
     C/COPY WNCPYSRC,TI0200C001
     C                   ELSE                                                   167727
     C                   MOVEL     SVDT          YY                             167727
     C     YY            IFLT      72                                           167727
     C                   MOVE      '2'           CINDV                          167727
     C                   ELSE                                                   167727
     C                   MOVE      '1'           CINDV                          167727
     C                   ENDIF                                                  167727
     C                   ENDIF                                                  167727
      *
     C                   WRITE     MGOREFD0                             99
      *
      **  Error on write to PF/MGOREFPD (message reference file)
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     007           DBASE                          ***************
     C                   MOVEL     'MGOREFPD'    DBFILE                         *DB ERROR 007 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * DETBRC - Determine branch from senders address
      *                                                               *
      * Called by WRTREF Write a record to PF/MGOREFPD                *
      * Calls     none                                                *
      *                                                               *
      *****************************************************************
     C     DETBRC        BEGSR
      *
      * If single branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVEL     BJSBRC        @@BRCA
     C                   GOTO      EDETBR
     C                   ENDIF
      *
      * Initialize output branch
      *
     C                   MOVEL     *BLANK        @@BRCA
      *
      * First check for first 8 characters and last 3 characters
      * of the senders address
      *
     C                   MOVEL     @@ADDR        @@BTID           11
     C                   MOVE      @@BRAN        @@BTID
      *
     C                   Z-ADD     1             X
     C     @@BTID        LOOKUP    @@BT(X)                                99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @@BC(X)       @@BRCA            3
     C                   ELSE
      *
      * Then check for just the first 8 characters
      * of the senders address
      *
     C                   MOVE      *BLANK        @@BTID
     C                   MOVEL     @@ADDR        @@BTID
      *
     C                   Z-ADD     1             X
     C     @@BTID        LOOKUP    @@BT(X)                                99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @@BC(X)       @@BRCA
     C                   ENDIF
      *
      * If none found, use first branch
      *
     C     @@BRCA        IFEQ      *BLANK
     C                   MOVEL     @@BC(1)       @@BRCA
     C                   ENDIF
     C                   ENDIF
      *
     C     EDETBR        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * CLRMOD - Clear the multiple occurence data structure          *
      *                                                               *
      * Called by FMTMSG Format messages for output                   *
      * Calls     none                                                *
      *                                                               *
      *****************************************************************
     C     CLRMOD        BEGSR
      *
      * Clear the multiple occurence data structure
      *
     C                   Z-ADD     1             X                 5 0
     C     X             OCCUR     MULT
      *
     C*****X*****        DOWLE     180                                          161185
     C*****X*****        DOWLE     500                                                 161185 235631
     C*****MULT**        ANDNE     *BLANKS                                                    235631
     C*****X****         DOWLT     500                                                 235631 243504
     C     X             DOWLE     999                                                        243504
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO
     C                   MOVE      *BLANKS       MULT                                         243504
      *
      * Point to the first element
      *
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
     C                   Z-ADD     1             X#LAST            5 0                        235631
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   Init - Initial Processing                                   *
      *                                                               *
      *   Called by MAIN  Main processing                             *
      *   Calls  *PSSR    Error handling                              *
      *          ZM0060   Convert Midas dayno to SWIFT date format    *
      *          AOBANKR0 access bank ICD details                     *
      *          AOSYTMR0 access external system ICD details          *
      *          AOMGMER0 access message management ICD details       *
      *          RCFAU    RCF Processing for Audit Report             *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      * Copyright Statement
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@DS              2
     C                   PARM                    @@BFL            10
     C                   PARM                    @@LIB            10
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **  Access SDBANKPD for report title
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on SDBANKPD
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     'FIRST   '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,TI0200C002
      *
      **  Access SDSYTMPD for message management data.
      *
     C                   CALL      'AOSYTMR0'
     C                   PARM      '*MSG   '     @RTCD
     C*****              PARM      '*FIRST '     @OPTN                          144804
     C                   PARM      '*KEY   '     @OPTN                          144804
     C                   PARM      'TI    '      @SYTM             6
     C     SDSYTM        PARM      SDSYTM        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'SDSYTMPD'    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     'FIRST   '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                         144804
      * Call access object to free SDSYTMPD:                                    144804
      *                                                                         144804
     C                   CALL      'AOSYTMR0'                                   144804
     C                   PARM      *BLANKS       @RTCD                          144804
     C                   PARM      '*FREE  '     @OPTN                          144804
     C                   PARM      'TI    '      @SYTM             6            144804
     C                   PARM      SDSYTM        DSFDY                          144804
      *                                                                         144804
     C     @RTCD         IFNE      *BLANKS                                      144804
     C     *LOCK         IN        LDA                                          144804
     C                   SETON                                          U7U8    144804
     C                   Z-ADD     009           DBASE                          144804 ********
     C                   MOVEL     'SDSYTMPD'    DBFILE                         144804 OR 009 *
     C                   MOVEL     '*FREE   '    DBKEY                          144804 ********
     C                   OUT       LDA                                          144804
     C                   EXSR      *PSSR                                        144804
     C                   ENDIF                                                  144804
      *
      ** Correctly work out Date Format
      *
     C     BJDFIN        COMP      'M'                                    98
      *
      **  Access SDMGMEPD for message management data.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE                          ***************
     C                   MOVEL     'SDMGMEPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     'FIRST   '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Convert run date to YYMMDD, for Message Generation Date
      *
     C                   CALL      'ZM0060'                             99
     C**********         PARM      BJRDNB        ZMDAY             5 0                        205236
     C                   PARM      AGRDNB        ZMDAY             5 0                        205236
     C                   PARM                    ZSDATE            6
      *
      ** Program ended in error.
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     004           DBASE                          ***************
     C                   MOVEL     'ZM0060  '    DBFILE                         *DB ERROR 004 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZSDATE        @@MGDE            6 0
      *
      **  Convert history retention date to YYMMDD
      *
     C*****BJRDNB        ADD       ENDSMN        ZMDAY                                        205236
     C     AGRDNB        ADD       ENDSMN        ZMDAY                                        205236
     C                   CALL      'ZM0060'                             99
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
      *
      ** If the program ends in error.
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE                          ***************
     C                   MOVEL     'ZM0060  '    DBFILE                         *DB ERROR 005 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZSDATE        @@HRDT            6
      *
      ** Read all branches on SDBRCHPD
      *
     C                   Z-ADD     0             X
     C     *LOVAL        SETLL     SDBRCHL0
     C                   READ      SDBRCHL0                               99    *
     C     *IN99         DOWNE     '1'
      *
      ** Store for each branch code both the first 8 and last
      ** 3 characters of the destination address,
      ** and purely the first 8 characters of the destination address
      *
     C                   ADD       1             X
     C                   MOVEL     A8BRCD        @@BC(X)
     C                   MOVEL     ADDR1B        @@BT(X)
     C                   MOVE      BRAN1B        @@BT(X)
     C**********         ADD       1             X                                            213308
     C**********         MOVEL     A8BRCD        @@BC(X)                                      213308
     C**********         MOVEL     ADDR1B        @@BT(X)                                      213308
     C                   READ      SDBRCHL0                               99    *
     C                   ENDDO
      *
      **  Initialise constant fields
      **   - CarriageReturn
      *
     C                   BITOFF    '01234567'    @@CR
     C                   BITON     '457'         @@CR
      **   - LineFeed
     C                   BITOFF    '01234567'    @@LF
     C                   BITON     '257'         @@LF
      *
     C                   Z-ADD     1             H                 5 0
     C                   Z-ADD     1             I                 5 0
      *                                                                                       CSW218
      ** Check if SWIFT 2018 is installed                                                     CSW218
      *                                                                                       CSW218
     C                   EVAL      POSSTR = *ZERO                                             CSW218
     C                   EVAL      POSEND = *ZERO                                             CSW218
     C                   EVAL      POSLEN = *ZERO                                             CSW218
     C                   EVAL      CSW218 = 'N'                                               CSW218
     C                   CALL      'SWIF2018'                                                 CSW218
     C                   PARM      *BLANKS       PRTCD                                        CSW218
                                                                                              CSW218
     C                   IF        PRTCD = 'CSW2018'                                          CSW218
     C                   EVAL      CSW218 = 'Y'                                               CSW218
     C                   ENDIF                                                                CSW218
      *
     C/COPY WNCPYSRC,TI0200C010
     C                   ENDSR
     C/COPY WNCPYSRC,TI0200C003
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - error handling                                      *
      *                                                               *
      *   Called by FMTMSG Format messages for output                 *
      *             OUTMSG Output the message to the messages file    *
      *             WRTREF Write a record to PF/MGOREFPD              *
      *             INIT   Initial processing                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      **  Database error
      *
     C                   ROLBK
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
      ***  Output Audit Report Header and DB Error Information.
      *
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
** CPY@   Object Copyright
(c) Finastra International Limited 2001

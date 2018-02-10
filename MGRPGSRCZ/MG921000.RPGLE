     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG Message cancellation processing')             *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation                                   *
      *                                                               *
      *  MG921000 - Midas MG Message Cancellation Processing          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD038127           Date 30Mar16               *
      *                 CSW216             Date 14Mar16               *
      *                 MD028094           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD038127 - System generated dump in DLC0210A                 *
      *           - Fix is to make sure that correct sequence number  *
      *             is used when generating messages for amend and    *
      *             delete action                                     *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD028094 - Deleted FXDN transaction created a cancellation   *
      *             entry on MGF300TR archive file                    *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
     FMGOREFL0  UF   E           K DISK
     F                                     RENAME(MGOREFD0:MGREFL0)
     FMGOREFL1  IF   F  406    16AIDISK    KEYLOC(9)
     FMGOMSGPD  UF A E           K DISK    COMMIT
     FDLRPIFL4  UF   E           K DISK    USROPN
     F                                     COMMIT
     FMGOREFPD  O    E             DISK    COMMIT
      *****************************************************************
     D GNR             S              3    DIM(15)
     D DSR             S              3    DIM(15)
     D @WRK            S              1    DIM(50)
     D CAN             S              3    DIM(6) CTDATA PERRCD(1)
     D CMD             S             80    DIM(1) CTDATA PERRCD(1)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D WMTPY           S              3
     D WMGST           S              4
     D #MTPY1          S              1
     D @KEY1           S             10
     D @KYST           S              7
     D TEST            S              3
     D NTPY            S              3
     D Z               S              2  0
     D HLSWS           S              3
     D @TRNO           S             16
     D RDATE           S              6
     D QCCMD           S             80
     D QCLEN           S             15  5
     D @MTPY           S              3
     D COUNT           S              2  0
     D @HEAD           S             16
     D RLSeq           S              2                                                     MD038127
 
      ** Multiple occurrence data structure for message
 
     D MULT            DS                  OCCURS(95)
     D  @MTAG                  1      5
     D  @MFLD                  6     55
 
      ** Data structure to hold the original message fields
      ** If MTAG only 4 characters then CHTAG will be blank; hence
      ** transpose MFLD into MFLD1 to remove the blank character
 
     D MSG             DS                  OCCURS(50)
     D  MTAG                   1      5
     D  MFLD1                  5     55
     D  MFLD2                  6     55
     D  CHTAG                  5      5
     D  MFLD3                  1     50
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data structure for bank details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Switchable Features File
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short data structure for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Local data area
 
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Rename fields to avoid override
 
     IMGOREFL1  NS
     I                                  9   24  TRNHDR
     I                                208  214  RELD
      *****************************************************************
      /EJECT
      *****************************************************************
      *   MAIN - Main process                                         *
      *****************************************************************
 
      ** Parameters passed to the program by the calling program.
      ** @TNUM is the transaction reference number of the message
      ** being cancelled.
      ** @MODI is the calling module id.
      ** @RTNC is used to inform the calling program of an error.
 
     C     *ENTRY        PLIST
     C                   PARM                    @TNUM            16
     C                   PARM                    @MODI             2
     C                   PARM                    @RTNC             1
 
      ** Initial process
 
     C                   EXSR      INIT
 
      ** Access LF/MGOREFL0 with the TRN parameter to access the
      ** cancelled message.
 
     C     @TNUM         CHAIN     MGOREFL0
 
      ** If no record of the message is not found.
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @TNUM         DBKEY
     C                   MOVEL     'MGOREFL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** If CDL008 is installed, save message type and status
 
     C     CDL008        IFEQ      'Y'
     C                   EVALR     WMTPY = MTPY
     C                   EVALR     WMGST = MGST
     C                   ENDIF
 
      ** Only proceed with the processing if cancellation requested
      ** flag for the message is not 'Y'.
 
     C                   IF        CARQ <> 'Y'
 
      ** Valid message types that produce cancellation messages
      **  MTn92
 
     C     MTPY          LOOKUP    CAN                                    14
 
      ** Also include cancellations for confirmations, and change
      ** to network of paper (non swift)
 
     C                   EVAL      #MTPY1 = MTPY
     C                   IF        *IN14 = *OFF
     C                             AND NWRK = 'SWIFT '
     C                             AND #MTPY1 = '3'
     C                             OR *IN14 = *OFF
     C                             AND NWRK = 'PAPER '
     C                             AND #MTPY1 = '3'
 
     C                   EVALR     *IN14 = *ON
 
     C                   END
 
      ** Determine if a cancellation message is valid for the
      ** destination customer type.
 
     C                   IF        *IN14 = '1'
     C                   EXSR      VALID
     C                   EXSR      CANCEL
     C                   END
 
      **  COMIT all file changes
 
     C                   COMMIT
     C                   END
 
     C                   CLOSE     DLRPIFL4
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *   VALID - Determine if cancellation messages are generated    *
      *           for destination customer.                           *
      *****************************************************************
     C     VALID         BEGSR
 
      ** Access SDCUSTPD for the destination customer details.
 
     C                   EVALR     @KEY1 = *BLANKS
     C                   MOVEL     DECN          @KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Customer record not found - Error
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   EVAL      DBKEY  = @KEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Is message type to be generated?
 
     C                   EVALR     GNR(1) = BBNG01
     C                   EVALR     GNR(2) = BBNG02
     C                   EVALR     GNR(3) = BBNG03
     C                   EVALR     GNR(4) = BBNG04
     C                   EVALR     GNR(5) = BBNG05
     C                   EVALR     GNR(6) = BBNG06
     C                   EVALR     GNR(7) = BBNG07
     C                   EVALR     GNR(8) = BBNG08
     C                   EVALR     GNR(9) = BBNG09
     C                   EVALR     GNR(10) = BBNG10
     C                   EVALR     GNR(11) = BBNG11
     C                   EVALR     GNR(12) = BBNG12
     C                   EVALR     GNR(13) = BBNG13
     C                   EVALR     GNR(14) = BBNG14
     C                   EVALR     GNR(15) = BBNG15
 
      ** Any of the following names can be entered on BBNGxx on
      ** SDCUSTPD to show the messages are not to be generated
      **  -'n92' where n is the 1st digit of the cancelled message type
      **  -'n9*' any of the n90 series of messages.
      **  -'n**' any of the 'n00' series of messages.
      **  -'*92' no cancellation messages are produced.
 
      ** Initially fill up the test field with 'n92' where n is the 1st
      ** digit of the message type.
 
     C                   EVALR     TEST = MTPY
     C**********         EVALR     TEST = '92'                                              MD028094
     C                   MOVE      '92'          TEST                                       MD028094
 
      ** Store the new msg type for later output.
 
     C                   EVALR     NTPY = TEST
 
      ** 'n92' valid
 
     C     TEST          LOOKUP    GNR                                    20
 
      ** 'n9*' valid
 
     C**********         EVALR     TEST = '*'                                               MD028094
     C                   MOVE      '*'           TEST                                       MD028094
 
     C     TEST          LOOKUP    GNR                                    21
 
      ** 'n**' valid
 
     C**********         EVALR     TEST = '**'                                              MD028094
     C                   MOVE      '**'          TEST                                       MD028094
 
     C     TEST          LOOKUP    GNR                                    22
 
      ** '*92' VALID
 
     C     '*92'         LOOKUP    GNR                                    23
 
      ** If the message is not to be generated seton LR.
 
     C                   IF        *IN20 = '1'
     C                             OR *IN21 = '1'
     C                             OR *IN22 = '1'
     C                             OR *IN23 = '1'
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   CANCEL - Create cancellation message (MTn92 processing)     *
      *****************************************************************
     C     CANCEL        BEGSR
 
     C                   EVAL      WWTNUM = @TNUM
 
     C     @TNUM         CHAIN     MGOMSGPD
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE
     C                   EVAL      DBKEY  = @TNUM
     C                   EVAL      DBFILE = 'MGOMSGPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C     MTAG          IFEQ      ':103:'
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   EVAL      @MTAG = MTAG
     C                   EVAL      @MFLD = MFLD
     C                   END
 
      ** Create the TRN for the new message
 
     C                   EXSR      TRAN
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   EVAL      @MTAG = ':20:'
     C                   EVALR     @WRK = *BLANKS
     C                   MOVEA     @MODI         @WRK
     C                   MOVEA     MTRN          @WRK(3)
     C                   Z-ADD     1             Z
 
     C     ' '           LOOKUP    @WRK(Z)                                99
 
     C**********         MOVEL     RILSWC        HLSWS                                      MD038127
     C**********         MOVEA     HLSWS         @WRK(Z)                                    MD038127
     C                   MOVEA     RLSeq         @WRK(Z)                                    MD038127
 
     C                   MOVEA     @WRK          @MFLD
     C                   EVAL      @TRNO = @MFLD
 
      ** Field 21: The related reference.
      ** Related Reference of new message = TRN of cancelled message.
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   EVAL      @MTAG = ':21:'
     C                   EVAL      @MFLD = WWTNUM
 
      ** Field 11.  - MT and Date of Original Message Record
      **              to LF/MGOMSGL0
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
 
     C                   EVAL                    @MTAG = ':11S:'
     C                   EVAL                    @MFLD = MTPY
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
 
      ** Format the release date via standard program ZM0085
 
     C                   EVAL      RDATE = *BLANKS
 
     C                   CALL      'ZM0085'                             15
     C                   PARM      RELD          @RELD             7
     C     RDATE         PARM      *BLANKS       @RDATE            6
 
      **  Call ended in error (Program not found)
 
     C                   IF        *IN15 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBFILE = 'ZM0085'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      @MFLD = RDATE
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
 
      **  Determine if message to be cancelled is single or multiple   ed.
 
     C                   EXSR      TYPE
 
      **  Perform single message cancellation.
 
     C                   EXSR      SINGLE
 
      ** Write the message to PF/MGOMSGPD
 
     C                   EXSR      OMSG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   SINGLE - Process MTn92 for a single message                 *
      *****************************************************************
     C     SINGLE        BEGSR
 
      ** Access PF/MGOMSGPD with the TRN of the cancelled message
 
     C     @TNUM         CHAIN     MGOMSGPD
 
      ** If no record is found.
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   EVAL      DBKEY  = @TNUM
     C                   EVAL      DBFILE = 'MGOMSGPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C     MTAG          IFEQ      ':103:'
     C                   READ      MGOMSGPD
     C                   END
 
      ** Move the TRN to the field to chain on in FILL subroutine.
 
     C                   EVAL      @HEAD = @TNUM
      *
     C                   EXSR      FILL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   TRAN - Retreive msg. seq. from transaction file             *
      *****************************************************************
     C     TRAN          BEGSR
 
      **  Put Midas Transaction Number into key valid for chain
 
     C                   MOVEL     MTRN          MTRAN             6 0
     C                   MOVEL     MTRAN         PIFKEY           16
 
      **  Dealing transaction
 
     C                   CALL      'QCAEXEC'
     C                   PARM      CMD(1)        QCCMD
     C                   PARM      80            QCLEN
 
     C                   OPEN      DLRPIFL4
     C     PIFKEY        CHAIN     DLRPIFL4
 
      **  Dealing transaction not found
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     MTRAN         DBKEY
     C                   EVAL      DBFILE = 'DLRPIFL4'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Increment S.W.I.F.T. seq. number & update appropriate file
 
     C**********         ADD       1             RILSWC            5 0                      MD038127
     C                   ADD       1             RICFNR                                     MD038127
     C                   MOVE      RICFNR        RLSeq                                      MD038127
 
      ** Dealing Reporting Info (API + Ref) update
 
     C                   UPDATE    DLRPIFD0
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   TYPE - Determine the type of message being cancelled        *
      *****************************************************************
     C     TYPE          BEGSR
 
      **  Initialise multiple message flag
 
     C                   EVALR     @MTPY = MTPY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   FILL - Write the original message to the data structure     *
      *****************************************************************
     C     FILL          BEGSR
 
     C                   EVAL      @MTAG = *BLANKS
 
      ** Remove possible space between MTAG & MFLD, (e.g. change
      ** ':21: ABCDEF0123FEDCBA' to ':21:ABCDEF0123FEDCBA')
 
     C                   IF        CHTAG = *BLANKS
     C                   EVAL      MFLD1 = MFLD
     C                   ELSE
     C                   EVAL      MFLD2 = MFLD
     C                   END
 
     C                   Z-ADD     1             COUNT             2 0
     C                   EVAL      @MFLD = MSG
     C                   READ      MGOMSGPD                               12
 
      **  Write the next record of the message being cancelled to the
      *** data structure
      **  Ensure that the MTn92 does not exceed 2,000 characters
 
     C                   DOW       @HEAD = TRNO
     C                             AND NOT %EOF
     C                             AND COUNT < 30
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
 
      ** Remove possible space between MTAG & MFLD, (e.g. change
      ** ':21: ABCDEF0123FEDCBA' to ':21:ABCDEF0123FEDCBA')
 
     C                   IF        CHTAG = *BLANKS
 
      ** If tag blank (next subfield/narrative line) left justify data
 
     C     MTAG          IFEQ      ' '
     C                   EVAL      MFLD3 = MFLD
     C                   ELSE
     C                   EVAL      MFLD1 = MFLD
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      MFLD2 = MFLD
     C                   ENDIF
      *
     C                   EVAL      @MFLD = MSG
     C                   READ      MGOMSGPD                               12
     C                   ADD       1             COUNT
 
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   WREF - Write a reference record to PF/MGOREFPD.             *
      *****************************************************************
     C     WREF          BEGSR
 
      ** Access LF/MGOREFL0 with the TRN parameter to access the
      ** cancelled message.
 
     C     WWTNUM        CHAIN     MGOREFL0
 
      ** If no record of the message is not found.
 
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE
     C                   EVAL      DBKEY  = WWTNUM
     C                   EVAL      DBFILE = 'MGOREFL0'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Update old record
 
     C                   EVAL      CARQ= 'Y'
     C                   EVAL      LADT = BJMRDT
     C                   TIME                    LATM
 
     C                   UPDATE    MGREFL0
 
      ** Write new record
 
     C                   EVAL      TRNO = @TRNO
     C                   EVALR     TRNF = *BLANKS
     C                   EVALR     TRNM = *BLANKS
     C                   MOVEL     MTRAN         MTRN
 
      ** Set up the msg. type dependant on the cancellation type
 
     C                   IF        *IN14 = '1'
     C                   EVAL      MTPY = NTPY
     C                   ELSE
     C                   EVAL      MTPY = MTPY
     C                   END
 
      ** Convert run date to YYMMDD, for Message Generation Date
 
     C                   CALL      'ZM0060'                             15
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZSDATE            6
 
      ** Program ended in error.
 
     C                   IF        *IN15 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE
     C                   EVAL      DBKEY  = '       '
     C                   EVAL      DBFILE = 'ZM0060'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVE      ZSDATE        MGDE
 
      ** Set-up Message Generation  Century flag
 
     C                   MOVEL     MGDE          YY                2 0
 
     C                   IF        YY < 72
     C                   EVALR     CIND = '2'
     C                   ELSE
     C                   EVALR     CIND = '1'
     C                   ENDIF
 
     C                   TIME                    MGTM
     C                   EVAL      LADT = BJMRDT
     C                   MOVE      MGTM          LATM
 
      ** If producing a confirmation cancellation - change network
      ** to non swift (for tram)
 
     C                   IF        #MTPY1 = '3'
     C                             AND CDL008 = 'N'
     C                             OR #MTPY1 = '3'
     C                             AND CDL008 = 'Y'
     C                             AND WMTPY <> '300'
     C                             OR #MTPY1 = '3'
     C                             AND CDL008 = 'Y'
     C                             AND WMTPY = '300'
     C                             AND WMGST = 'DLTD'
 
     C                   EVAL      NWRK = 'PAPER'
     C                   EVALR     MGST = 'PRTD'
     C                   EVALR     MGSG = '3'
 
     C                   ELSE
 
      ** Check default status on customer record
 
     C                   EVALR     DSR(1) = BBDS01
     C                   EVALR     DSR(2) = BBDS02
     C                   EVALR     DSR(3) = BBDS03
     C                   EVALR     DSR(4) = BBDS04
     C                   EVALR     DSR(5) = BBDS05
     C                   EVALR     DSR(6) = BBDS06
     C                   EVALR     DSR(7) = BBDS07
     C                   EVALR     DSR(8) = BBDS08
     C                   EVALR     DSR(9) = BBDS09
     C                   EVALR     DSR(10) = BBDS10
     C                   EVALR     DSR(11) = BBDS11
     C                   EVALR     DSR(12) = BBDS12
     C                   EVALR     DSR(13) = BBDS13
     C                   EVALR     DSR(14) = BBDS14
     C                   EVALR     DSR(15) = BBDS15
 
     C                   MOVEL     MTPY          W@MTPY            3
     C     W@MTPY        LOOKUP    DSR                                    50
 
     C                   IF        NOT %FOUND
     C**********         EVALR     W@MTPY = '*'                                             MD028094
     C                   MOVE      '*'           W@MTPY                                     MD028094
     C     W@MTPY        LOOKUP    DSR                                    50
     C                   ENDIF
 
     C                   IF        NOT %FOUND
     C**********         EVALR     W@MTPY = '**'                                            MD028094
     C                   MOVE      '**'          W@MTPY                                     MD028094
     C     W@MTPY        LOOKUP    DSR                                    50
     C                   ENDIF
 
     C                   IF        NOT %FOUND
     C                   EVALR     W@MTPY = '***'
     C     W@MTPY        LOOKUP    DSR                                    50
     C                   ENDIF
 
     C                   IF        %FOUND
     C                   EVAL      MGSG = '2'
     C                   EVAL      MGST = 'RSND'
     C                   ELSE
     C                   EVALR     MGST = 'CRTD'
     C                   EVALR     MGSG = '1'
     C                   END
 
     C                   END
 
     C                   EVALR     CARQ = *BLANK
 
     C                   EVAL      PTST = *BLANKS
     C                   EVAL      MPDE = *BLANKS
     C                   EVALR     RELD = *BLANKS
     C                   MOVE      *BLANKS       RELT
     C                   EVAL      RUSR = *BLANKS
     C                   EVAL      RWSN = *BLANKS
 
     C                   EVALR     CFPF = *BLANKS
     C                   EVALR     TSKS = *BLANKS
     C                   EVALR     TSKY = *BLANKS
     C                   Z-ADD     0             PT210
     C                   Z-ADD     0             AVDT
     C                   Z-ADD     0             ASEQ
     C                   EVALR     TODY = *BLANKS
 
      ** Blank out Event Type
 
     C                   EVALR     EVTP = *BLANKS
 
     C                   WRITE     MGOREFD0                             05
 
      ** Error on write to PF/MGOREFPD (message reference file)
 
     C                   IF        *IN05 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE
     C                   EVAL      DBKEY  = '       '
     C                   EVAL      DBFILE = 'MGOREFPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   OMSG - output correctly generated messages                  *
      *****************************************************************
     C     OMSG          BEGSR
 
      ** Write reference record to PF/MGOREFPD.
 
     C                   EXSR      WREF
 
      **  Write multiple occurrence data structure to MGOMSGPD
 
     C                   Z-ADD     1             X                 2 0
     C     X             OCCUR     MULT
 
     C                   DOW       X = 40
     C                             AND @MFLD <> *BLANKS
     C                             OR X < 40
     C                             AND @MFLD <> *BLANKS
 
      ** Move the fields to be output to the field names on
      ** the file.
 
     C                   EVAL      MFLD = @MFLD
     C                   EVAL      MTAG = @MTAG
     C                   EVALR     PTDL = *BLANKS
 
     C                   WRITE     MGOMSGD0                             06
 
      ** Error on write to PF/MGOMSGPD (message data file)
 
     C                   IF        *IN06 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE
     C                   EVAL      DBKEY  = '       '
     C                   EVAL      DBFILE = 'MGOMSGPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   INIT - Initial Processing                                   *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Set up LDA
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVALR     DBFILE = *BLANKS
     C                   EVALR     DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = 'MG921000'
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
 
      ** Initialise constant fields
 
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   EVALR     CRLF = LF
     C                   EVAL      TRNO = @TNUM
     C                   EVALR     PTDL = *BLANKS
 
      ** CRLF Control Character for message data records
 
     C                   EVALR     CTRC = CRLF
 
      ** Access SDBANKPD for run date and date format
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C/COPY WNCPYSRC,MG9210C006
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If no record is found on SDBANKPD
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     15            DBASE
     C                   EVAL      DBKEY  = 'FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if CDL008 (Continuous Linked Settlement) is installed
 
     C                   MOVE      'N'           CDL008            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'CDL008'      WSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        WRTCD <> *BLANKS
     C                             AND WRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     21            DBASE
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = WSARD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WRTCD = *BLANK
     C                   MOVEL     'Y'           CDL008
     C                   ENDIF
 
     C     *LIKE         DEFINE    @TNUM         WWTNUM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   *PSSR - Error handling                                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVALR     @RTNC = 'E'
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Added missing array CMD for QCAEXEC                                                MD028094
** CAN - Message types requiring an MTn92.
300
** CMD
OVRDBF DEALS SHARE(*NO)
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365

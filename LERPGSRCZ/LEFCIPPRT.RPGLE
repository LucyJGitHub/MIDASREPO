     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STDz*  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Participant screen-field convert')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LEFCIPPRT -  Facility Participant Details Screen-Database    *
      *               Field Conversion                                *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10540           Date 14Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  BUG10540 - Add new assignment indicator. (Recompile)         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(75)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
      * Valid Facility FM layout -> FCLTYFM

     D TranInPrtn    E DS                  EXTNAME(LEFCZPPD)
      * Incoming Transaction

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Bank Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * Customer Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EXSR      RESETERRS
      *
      ** Convert participant fields from screen into database field format
     C                   EXSR      Convert
      *
     C                   EXSR      UPDATERRS
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      * RETURN
     C                   RETURN
      ******************************************************************************
      ** CONVERT - Convert participant fields from screen into database field format
      ******************************************************************************
     C     CONVERT       BEGSR
      *
      **  Prime Facility Customer
      *
     C     DDPMFC        IFNE      *BLANKS
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDPMFC        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Add       1             Idx
     C                   Movel     'DDPMFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0522'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE(P)   BBCUST        DDPMFC
     C                   ENDIF
     C                   ENDIF
      *
      **  Introducing Customer
      *
     C     DDINUM        IFNE      *BLANKS
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDINUM        @CNUM
     C                   PARM                    @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Add       1             Idx
     C                   Movel     'DDINUM'      FldNamXAr(Idx)
     C                   Movel     'LEF0523'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE(P)   BBCUST        DDINUM
     C                   ENDIF
     C                   ENDIF
      *
      **  Joining Date
      *
     C                   Z-ADD     *ZERO         W#JDTE            5 0
     C     DDJDTE        IFNE      *BLANKS
     C                   MOVE      DDJDTE        DATEA
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   Add       1             Idx
     C                   Movel     'DDJDTE'      FldNamXAr(Idx)
     C                   Movel     'LEF0524'     MsgIDXAr(Idx)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        W#JDTE
     C                   ENDIF
     C                   ENDIF
      *
      **  Share Percentage
      *
     C                   MOVE      *ZERO         W#SHPC           15 0
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDSHPC        ZFIELD
     C                   Z-ADD     12            ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'N'
     C                   Add       1             Idx
     C                   Movel     'DDSHPC'      FldNamXAr(Idx)
     C                   Movel     'LEF0525'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SHPC
     C                   ENDIF
      *
      **  Interest Skim Rate
      *
     C                   MOVE      *ZERO         W#SKIR           11 7
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDSKIR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'N'
     C                   Add       1             Idx
     C                   Movel     'DDSKIR'      FldNamXAr(Idx)
     C                   Movel     'LEF0526'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SKIR
     C                   ENDIF
      *
      **  Fees Skim Rate
      *
     C                   MOVE      *ZERO         W#SKFR           11 7
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDSKFR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN2
     C     ZALIGNok      IFEQ      'N'
     C                   Add       1             Idx
     C                   Movel     'DDSKFR'      FldNamXAr(Idx)
     C                   Movel     'LEF0527'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SKFR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * File LEVFCIMPD - FM file

     C                   MOVE      DDPMFC        FPPMFC
     C                   MOVE      DDPMFT        FPPMFT
     C                   MOVE      DDPMFN        FPPMFN
     C                   MOVE      DDINUM        FPINUM
     C                   MOVE      DDRCSI        FPRCSI
     C                   Z-ADD     W#JDTE        FPJDTE
     C                   MOVE      DDPASI        FPPASI
     C                   MOVE      DDSHTP        FPSHTP
     C                   Z-ADD     W#SHPC        FPSHPC
     C                   Z-ADD     W#SKIR        FPSKIR
     C                   MOVE      DDSKIS        FPSKIS
     C                   Z-ADD     W#SKFR        FPSKFR
     C                   MOVE      DDSKFS        FPSKFS
     C                   MOVE      DDCOAG        FPCOAG
     C                   MOVE      DDFCAG        FPFCAG
     C                   MOVE      DDPHAG        FPPHAG
     C                   MOVE      DDSCAG        FPSCAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZALIGN2       BEGSR
     C                   CALLB     'ZALIGN2'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      ** Participant Details
     C                   PARM                    TranInPrtn

      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
      *
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFCIPPRT'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information                           *
      *****************************************************************

     C     RESETERRS     BEGSR
      *
      * Reset error fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information                          *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2005

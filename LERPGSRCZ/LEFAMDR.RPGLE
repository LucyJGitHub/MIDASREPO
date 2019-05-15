     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment retrieve')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFAMDR - Facility Amendement Read                           *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD052402           Date 23Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG11161           Date 06Mar06               *
      *                 BUG10384           Date 06Feb06               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 07Jul05               *
      *                 CAP084  *CREATE    Date 16Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052402 - Issue with WIP for Facility Events.               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00226                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11161 - Add hidden fields from FAMD.xml (Recompile)       *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CLE106 - Syndications Manager. Facility event UTN was re-    *
      *           trieved from file.                                  *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  CAP084 - API wrapper project                                 *
      *                                                               *
      *****************************************************************


      **---------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** SCREEN FORMATS
      **---------------------------------------------------------------

      ** Facility Amendment Details in screen format
     DFAMDScrFmt     E DS                  EXTNAME(LEFAMDPD)
     D                                     PREFIX(S2:2)
      *                                                                                       CLE106
      ** Facility Amendment Details 2 in screen format                                        CLE106
      *                                                                                       CLE106
     DFAM2ScrFmt     E DS                  EXTNAME(LEFAM2PD)                                  CLE106

      **---------------------------------------------------------------
      ** FILE FORMATS
      **---------------------------------------------------------------

      ** Facility Amendment Details in file format
     DFAMDFilFmt     E DS                  EXTNAME(LEFCAMPD)

      **---------------------------------------------------------------
                                                                                            MD052402
      ** Interface Data Format Definition File format                                       MD052402
     D InfData       E DS                  EXTNAME(LELEIFPD)                                MD052402
     D                                     PREFIX(IF_)                                      MD052402

      ** Index for arrays of of error message ids etc
     DIdx              S              3P 0

      ** Index for arrays of warning message ids etc
     DWIdx             S              3P 0
      *                                                                                       CLE106
      ** Work Variable for Facility Event UTN                                                 CLE106
      *                                                                                       CLE106
     D CLE106          S              1A                                                      CLE106
      *                                                                                       CLE106

     DOutCustShtNm     S                   LIKE(S#CSSN)
     DOutFacility      S                   LIKE(S#FACT)
     DOutFctyNumb      S                   LIKE(S#FCNO)
     DOutFctyType      S                   LIKE(S#FATP)
     DOutValueDte      S                   LIKE(S#VLDT)
     DOutSeqNumb       S                   LIKE(S#SQNO)


      * Facility run dates
     D  @RUNA          DS
     D  FC_RUN0                1      5  0
     D  FC_RUN1                6     10  0
     D  FC_RUN2               11     15  0
     D  FC_RUN3               16     20  0
     D  FC_RUN4               21     25  0
     D  FC_RUN5               26     30  0
     D  FC_RUN6               31     35  0
     D  FC_RUN7               36     40  0
     D  FC_RUN8               41     45  0
     D  FC_RUN9               46     50  0
     D  @FC_RUN                1     50  0
     D                                     DIM(10)

      * Facility drawn amounts
     D  @OAMA          DS
     D  FC_OAM1                1     13  0
     D  FC_OAM2               14     26  0
     D  FC_OAM3               27     39  0
     D  FC_OAM4               40     52  0
     D  FC_OAM5               53     65  0
     D  FC_OAM6               66     78  0
     D  FC_OAM7               79     91  0
     D  FC_OAM8               92    104  0
     D  FC_OAM9              105    117  0
     D  FC_OA10              118    130  0
     D  @FC_OAM                1    130  0
     D                                     DIM(10)

      **-----------------------------------------------------------------------

     C                   CLEAR                   FAMDFilFmt
     C     S#ACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           S#ACTN
     C                   ELSE
     C                   MOVEL     'E'           S#ACTN
     C                   ENDIF
     C                   ENDIF

     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF

     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      LEFAMDRED
     C                   ELSE
     C                   MOVEL     *BLANK        @ERRMS
     C                   EVAL      OutCustShtNm = S#CSSN
     C                   EVAL      OutFacility  = S#FACT
     C                   EVAL      OutFctyNumb  = S#FCNO
     C                   EVAL      OutFctyType  = S#FATP
     C                   EVAL      OutValueDte  = S#VLDT
     C                   EVAL      OutSeqNumb   = S#SQNO
     C                   ENDIF
      *
      * If facility amendment read
      * and no error message returned
      *
     C     OutCustShtNm  IFNE      *BLANK
     C     OutFacility   ANDNE     *BLANK
     C     OutFctyNumb   ANDNE     *BLANK
     C     OutFctyType   ANDNE     *BLANK
     C     OutValueDte   ANDNE     *BLANK
     C     OutSeqNumb    ANDNE     *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve facility amendement details
      *
     C                   EXSR      LEFAMDRTV
     C     CLE106        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
      ** Facility Events UTN was extracted                                                    CLE106
      *                                                                                       CLE106
     C                   EVAL      S#UTN = PCRF                                               CLE106
     C                   EVAL      S2NPRT = NPRT                                              CLE106
     C                   ENDIF                                                                CLE106
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      LEFAMDCVT
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'S#FACT'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

     C                   EVAL      IF_FILLER =   S#CNUM + S#CSNM + S#CRNM                   MD052402
     C                                         + S#CRTN + S#FATN + S#STAT                   MD052402
     C                                         + S#VLDA                                     MD052402
                                                                                            MD052402
     C                   EVAL                    Buffer = FAMDScrFmt
     C                                           + FAM2ScrFmt                                 CLE106
     C                                           + InfData                                  MD052402
     C**********                                 + S#CNUM + S#CSNM + S#CRNM                 MD052402
     C**********                                 + S#CRTN + S#FATN + S#STAT                 MD052402
     C**********                                 + S#VLDA                                   MD052402

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
      *
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LEFAMDM01
     C                   ENDSR

      **********************************************************************
     C     LEFAMDRED     BEGSR

     C                   CALLB     'LEFAMDRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO
     C                   PARM                    S#FATP
     C                   PARM                    S#VLDT
     C                   PARM                    S#SQNO
      *
      * Read Forward
     C                   PARM                    @RDFWD            1
      *
      * Read Backward
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error Message
     C                   PARM                    @ERRMS            7
      *
      * Facility number read
     C                   PARM                    OutCustShtNm
     C                   PARM                    OutFacility
     C                   PARM                    OutFctyNumb
     C                   PARM                    OutFctyType
     C                   PARM                    OutValueDte
     C                   PARM                    OutSeqNumb
     C                   ENDSR
      **********************************************************************
     C     LEFAMDRTV     BEGSR
      ** Fill the input parameters by the key returned by LEFAMDRED
     C                   EVAL      S#CSSN = OutCustShtNm
     C                   EVAL      S#FACT = OutFacility
     C                   EVAL      S#FCNO = OutFctyNumb
     C                   EVAL      S#FATP = OutFctyType
     C                   EVAL      S#VLDT = OutValueDte
     C                   EVAL      S#SQNO = OutSeqNumb
      *
     C                   CALLB     'LEFAMDRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      'S'           RESPMODE          1

      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3

      *
      * OUTPUTS

      * Facility Amendment Details in file format
     C                   PARM                    FAMDFilFmt

      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1

      * Customer number
     C                   PARM                    S#CNUM           10

      * Value date of amendment
     C                   PARM                    W#VLDT            5 0

      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00226

      * Facility run dates
      * Facility drawn amounts
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN                                     BUG10384
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
     C                   ENDSR
      **********************************************************************
     C     LEFAMDCVT     BEGSR

     C                   CALLB     'LEFAMDCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility Amendment details in file format
     C                   PARM                    FAMDFilFmt

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Facility Amendment Details in screen format
     C                   PARM                    FAMDScrFmt

      * Customer details
     C                   PARM                    S#CNUM
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10

      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT Retrieve a detail record')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1012R  - Midas FT RFT retrieve a detail record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. 254598             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG1972            Date 20Apr04               *
      *                 222373             Date 27Oct03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  254598 - Increase length of DP32B and DATA2 (JMI106/113)     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  BUG1972 - system hangs when inserting RFT details            *
      *  222373 - Parameter mismatch                                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

     D/COPY MECPYSRC,ME1100_ILE
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------

     D DealScnFmt    E DS                  EXTNAME(FT101DSPD) PREFIX(D)
     D
      * Deal in screen format


      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

     D DealFilFmt    E DS                  EXTNAME(FT101DPD)
      ** Deal in file format

      **-----------------------------------------------------------------------
     D MREFARR         S              8    DIM(100)
      ** Message reference array

     D MPRTARR         S              3    DIM(100)
      ** Message part array

     D OkRftDtB      E DS                  EXTNAME(FTE101BPD)
      ** EXTERNAL DS FOR OK FLAGS DETAIL

     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc

     D WIdx            S              3P 0
      ** Index for arrays of warning message ids etc
                                                                                              222373
      ** Message reference (input parameter)                                                  222373
     D MGMSGR          S                   LIKE(PHMSGR)                                       222373

      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    RFTID_IN         15
     C                   PARM                    TRANR_IN         16
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTM102M01

      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
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
     C                   EXSR      FTM1012RD
     C                   ELSE
     C                   MOVEL     RFTID_IN      @RFTID
     C                   MOVEL     TRANR_IN      @TRANR
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @RFTID <> *Blank and @TRANR <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @RFTID        @@RFTID
     C                   MOVEL     @TRANR        @@TRANR
     C                   EXSR      FTM1012RV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FTM1012CT
     C                   ENDIF

     C                   ENDIF

     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'PRFTHDR'     FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

      * Build buffer with required output
     C                   EVAL                    Buffer = DDACTN+DealScnfmt

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FTM1012RD     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1012RD'
      * Return code
     C                   PARM                    RetCodeOut

      * Action code
     C                   PARM                    DDACTN            1

      * RFT ID
     C                   PARM      RFTID_IN      WRFTID           15

      * Transaction reference
     C                   PARM      TRANR_IN      WTRANR           16

      * Read forwards
     C                   PARM                    @RDFWD            1

      * Read backwards
     C                   PARM                    @RDBCK            1

      * Error message
     C                   PARM      *BLANK        @ERRMS            7

      * RFT ID
     C                   PARM      *BLANK        @RFTID           15

      * Transaction reference
     C                   PARM      *BLANK        @TRANR           16

      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20

     C                   ENDSR
      **********************************************************************
     C     FTM1012RV     BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1012RV'

      * Return code
     C                   Parm                    RetCodeOut
      * Action Code
     C                   Parm                    DDACTN            1
      * (Midas) RFT ID
     C                   Parm                    @@RFTID          15
     C                   Parm                    @@TRANR          16
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
     C                   Parm      *BLANKS       SQ101B            2
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * RFT Header Record
     C                   Parm                    DealFilFmt
      * Key Pressed
     C                   Parm      *BLANKS       @KeyP             2
      * Details of the message
     C                   Parm                    Phead
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      * Message ref array
     C                   PARM                    MREFARR
      * Message part array
     C                   PARM                    MPRTARR

      ** Errors produced during retrieve operation
     C                   Parm                    OkRftDTB
     C                   Parm                    IDx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr

     C                   ENDSR
      **********************************************************************
     C     FTM1012CT     BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1012CT'
      * Return Code
     C                   Parm                    RetCodeOut
      *                                                                         BUG1972
      ** Action Code                                                            BUG1972
      *                                                                         BUG1972
     C                   Parm                    Actn              1            BUG1972
      *
      * Type of Conversion
      *
     C                   Parm      'SC'          CnvTyp            2
      *
      * RFT Header Details in file format
      *
     C                   Parm                    DealFilFmt
      *
      * MT101 details in message format
      *
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      *
      * RFT details in screen format
      *
     C                   Parm                    DealScnFmt

     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT Retrieve a detail record')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1022R  - Midas FT CCT retrieve a detail record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG1972            Date 20Apr04               *
      *                 222373             Date 27Oct03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
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
 
     D DealScnFmt    E DS                  EXTNAME(FT102DSPD) PREFIX(D)
     D
      * Deal in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(FT102DPD)
      ** Deal in file format
 
      **-----------------------------------------------------------------------
     D MREFARR         S              8    DIM(100)
      ** Message reference array
 
     D MPRTARR         S              3    DIM(100)
      ** Message part array
 
     D OkCCTDtB      E DS                  EXTNAME(FTE102BPD)
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
     C                   PARM                    CCTID_IN         15
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
     C                   EXSR      FTM1022RD
     C                   ELSE
     C                   MOVEL     CCTID_IN      @CCTID
     C                   MOVEL     TRANR_IN      @TRANR
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @CCTID <> *Blank and @TRANR <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @CCTID        @@CCTID
     C                   MOVEL     @TRANR        @@TRANR
     C                   EXSR      FTM1022RV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FTM1022CT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'PCCTID'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = DDACTN+DealScnfmt
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FTM1022RD     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1022RD'
      * Return code
     C                   PARM                    RetCodeOut
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * CCT ID
     C                   PARM      CCTID_IN      WCCTID           15
 
      * Transaction reference
     C                   PARM      TRANR_IN      WTRANR           16
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
 
      * CCT ID
     C                   PARM      *BLANK        @CCTID           15
 
      * Transaction reference
     C                   PARM      *BLANK        @TRANR           16
 
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     FTM1022RV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1022RV'
 
      * Return code
     C                   Parm                    RetCodeOut
      * Action Code
     C                   Parm                    DDACTN            1
      * (Midas) CCT ID
     C                   Parm                    @@CCTID          15
     C                   Parm                    @@TRANR          16
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
     C                   Parm      *BLANKS       SQ102B            2
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * CCT Header Record
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
     C                   Parm                    OkCCTDTB
     C                   Parm                    IDx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
     C                   ENDSR
      **********************************************************************
     C     FTM1022CT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1022CT'
      * Return Code
     C                   Parm                    RetCodeOut
      *                                                                         BUG1972
      ** Action Code                                                            BUG1972
      *                                                                         BUG1972
     C                   Parm                    Actn              1            BUG1972
      *
      * MT102 details in message format
      *
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      * Type of Conversion
      *
     C                   Parm      'SC'          CnvTyp            2
      *
      * CCt Header Detail
     C                   PARM      *BLANKS       @CCttyp           2
     C                   PARM      *BLANKS       @FilRef          16
      *
      * CCT Header Details in file format
      *
     C                   Parm                    DealFilFmt
      *
      *
      * CCT details in screen format
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

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT Retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1021R  - Midas FT CCT retrieve a record                   *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25761           Date 27Aug09               *
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG1944            Date 20Apr04               *
      *                 222373             Date 27Oct03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG25761 - A serious midas error occurred message appears    *
      *             when edit button is clicked                       *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - Swift 2009 Changes (Recompiled)                     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  BUG1944 - Edit RFTD give Blank input form                    *
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
 
     D DealScnFmt    E DS                  EXTNAME(FT102HSPD) PREFIX(H)
     D
      * Deal in screen format
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(FT102HPD)
      ** Deal in file format
 
      **-----------------------------------------------------------------------
     D MREFARR         S              8    DIM(100)
      ** Message reference array
 
     D MPRTARR         S              3    DIM(100)
      ** Message part array
 
     D OkCCTHdr      E DS                  EXTNAME(FTE102HBPD)
      ** EXTERNAL DS FOR OK FLAGS HEADER
 
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
     C                   EXSR      FTM1021RD
     C                   ELSE
     C                   MOVEL     CCTID_IN      @CCTID
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @CCTID <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @CCTID        @@CCTID
     C                   EXSR      FTM1021RV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FTM1021CT
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
     C     FTM1021RD     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1021RD'
      * Return code
     C                   PARM                    RetCodeOut
 
      * Action code
     C                   PARM                    DDACTN            1
 
      * CCT ID
     C                   PARM      CCTID_IN      WCCTID           15
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
 
      * CCT ID
     C                   PARM      *BLANK        @CCTID           15
 
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     FTM1021RV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1021RV'
 
      * Return code
     C                   Parm                    RetCodeOut
      * Action Code
     C                   Parm                    DDACTN            1
      * CCT type
     C                   Parm      *BLANKS       @CCTTyp           2
      * File ref
     C                   Parm      *BLANKS       @FilRef          16
      * (Midas) CCT ID
     C                   Parm                    @@CCTID          15
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * CCT Header Record
     C                   Parm                    DealFilFmt
      * Key Pressed
     C                   Parm      *BLANKS       @KeyP             2
      * Details of the message
     C                   Parm                    PDATA
      ** Details of the message (Extension)                                                 BUG25761
     C                   PARM                    PDat2                                      BUG25761
      * Message ref array
     C                   PARM                    MREFARR
      * Message part array
     C                   PARM                    MPRTARR
 
      ** Errors produced during retrieve operation
     C                   Parm                    OkCCTHdr
     C                   Parm                    IDx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
     C                   ENDSR
      **********************************************************************
     C     FTM1021CT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1021CT'
      * Return Code
     C                   Parm                    RetCodeOut
      *                                                                         BUG1944
      ** Action Code                                                            BUG1944
      *                                                                         BUG1944
     C                   Parm                    Actn              1            BUG1944
      *
      * MT102 details in message format
      *
     C                   Parm                    PDATA
      *                                                                                     BUG25761
      ** Details of the message (Extension)                                                 BUG25761
      *                                                                                     BUG25761
     C                   PARM                    PDat2                                      BUG25761
      *
      ** Message reference
      *
     C                   PARM                    MGMSGR
      *
      * Type of Conversion
      *
     C                   Parm      'SH'          CnvTyp            2
      *
      * CCT Header Details in file format
      *
     C                   Parm                    DealFilFmt
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

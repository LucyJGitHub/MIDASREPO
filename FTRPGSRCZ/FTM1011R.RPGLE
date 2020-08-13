     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT Retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1011R  - Midas FT RFT retrieve a record                   *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG1944            Date 20Apr04               *
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

     D DealScnFmt    E DS                  EXTNAME(FT101HSPD) PREFIX(H)
     D
      * Deal in screen format


      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

     D DealFilFmt    E DS                  EXTNAME(FT101HPD)
      ** Deal in file format

      **-----------------------------------------------------------------------
     D MREFARR         S              8    DIM(100)
      ** Message reference array

     D MPRTARR         S              3    DIM(100)
      ** Message part array

     D OkRftHdr      E DS                  EXTNAME(FTE101HBPD)
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
     C                   PARM                    RFTID_IN         15
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
     D/COPY WNCPYSRC,FTM101M01

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
     C                   EXSR      FTM1011RD
     C                   ELSE
     C                   MOVEL     RFTID_IN      @RFTID
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        @ERRMS = *BLANK and
     C                             @RFTID <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @RFTID        @@RFTID
     C                   EXSR      FTM1011RV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FTM1011CT
     C                   ENDIF

     C                   ENDIF

     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'PRFTID'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

      * Build buffer with required output
     C                   EVAL                    Buffer = DDACTN+DealScnfmt

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FTM1011RD     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1011RD'
      * Return code
     C                   PARM                    RetCodeOut

      * Action code
     C                   PARM                    DDACTN            1

      * RFT ID
     C                   PARM      RFTID_IN      WRFTID           15

      * Read forwards
     C                   PARM                    @RDFWD            1

      * Read backwards
     C                   PARM                    @RDBCK            1

      * Error message
     C                   PARM      *BLANK        @ERRMS            7

      * RFT ID
     C                   PARM      *BLANK        @RFTID           15

      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20

     C                   ENDSR
      **********************************************************************
     C     FTM1011RV     BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1011RV'

      * Return code
     C                   Parm                    RetCodeOut
      * Action Code
     C                   Parm                    DDACTN            1
      * Rft type
     C                   Parm      *BLANKS       @RftTyp           2
      * (Midas) RFT ID
     C                   Parm                    @@RFTID          15
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * RFT Header Record
     C                   Parm                    DealFilFmt
      * Key Pressed
     C                   Parm      *BLANKS       @KeyP             2
      * Details of the message
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      * Message ref array
     C                   PARM                    MREFARR
      * Message part array
     C                   PARM                    MPRTARR

      ** Errors produced during retrieve operation
     C                   Parm                    OkRftHdr
     C                   Parm                    IDx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr

     C                   ENDSR
      **********************************************************************
     C     FTM1011CT     BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FTM1011CT'
      * Return Code
     C                   Parm                    RetCodeOut
      *                                                                         BUG1944
      ** Action Code                                                            BUG1944
      *                                                                         BUG1944
     C                   Parm                    Actn              1            BUG1944
      *
      * Type of Conversion
      *
     C                   Parm      'SH'          CnvTyp            2
      *
      * RFT Header Details in file format
      *
     C                   Parm                    DealFilFmt
      *
      * MT101 details in message format
      *
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      ** Message reference
      *
     C                   PARM                    MGMSGR
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

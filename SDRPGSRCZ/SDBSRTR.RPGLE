     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base rate codes retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Standing data module                                 *
      *                                                               *
      *  SDBSRTR - SD Base rate codes retrieve a record               *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG4660            Date 08Nov04               *
      *                 BUG4469            Date 06Oct04               *
      *                 CAP084  *CREATE    Date 15Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG4660 - Current Base Rate must not be updated during amend.*
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************

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

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------

     D BasRScnFmt    E DS                  EXTNAME(SDBSRSPD)
      * Base rates in screen format

      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

     D BasRFilFmt    E DS                  EXTNAME(SDBSRTPD)
      ** Base rates in file format

      **-----------------------------------------------------------------------

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      **-----------------------------------------------------------------------

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure

      * Fields defined for CSD012
     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')

      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
                                                                                              CSD103
      * SD Extra data in file (D/B) format                                                    CSD103
     D ExtData       E DS                  EXTNAME(SDBSEXPD)                                  CSD103
      **  Data Structure for Backward-Looking Rate Fields                                     CSD103
     DBasRBckfld       DS            27                                                       CSD103

      ** +--- Start of main processing -----------------------------------+

     C                   CLEAR                   BasRFilFmt

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
     C                   EXSR      SDBSRTRED
     C                   ELSE
     C                   MOVEL     DDBSRC_In     @BSRCRed
     C                   MOVEL     DDCYCD_In     @CYCDRed
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If base rate read and no error message returned
     C     @BSRCRed      IFNE      *BLANK
     C     @CYCDRed      ANDNE     *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve base rate details
     C                   MOVEL     'E'           DDACTN
     C                   MOVEL     @BSRCRed      DDBSRC
     C                   MOVEL     @CYCDRed      DDCYCD
     C                   MOVEL     'S'           APRespMode
     C                   EXSR      SDBSRTRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDBSRTCVT
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDBSRS'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

      * Build buffer with required output
     C                   MOVE      BATMST        @TimeStamp       26                         BUG4469
     C     AUTHRQ        IFEQ      'Y'                                                        CSD103
     C                   MOVE      'N'           AUTOAUTH          1                          CSD103
     C                   ELSE                                                                 CSD103
     C                   MOVE      'Y'           AUTOAUTH          1                          CSD103
     C                   ENDIF                                                                CSD103
     C                   EVAL      Buffer = BasRScnfmt                                        CSD103
     C                                      + @TimeStamp                                     BUG4469
     C                                      + ExtData                                         CSD103
     C                                      + AUTOAUTH                                        CSD103
     C                                      + BasRBckfld                                      CSD103

     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCYCD_IN         3
     C                   PARM                    DDBSRC_IN         2
     C                   PARM                    Buffer         3000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,SDBSRTVM01
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '100'         DBASE                          * DBERR 100 *
     C                   EXSR      *PSSR                                        *************
     C                   END

      ** Check if CSD012 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD012'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF

      ** If CSD012 is ON, check if base rate authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
     C     SVAL11        IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF

     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SDBSRTR'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If base rate authorisation is On set to authorise
     C     SVAL1         IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ            1
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     SDBSRTRED     BEGSR
      **********************************************************************
      *
     C                   CALLB     'SDBSRTRED'
      *
      * Input parameters
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM                    DDACTN
      *
      * Base rate currency and code
     C                   PARM      DDCYCD_In     DDCYCD            3
     C                   PARM      DDBSRC_In     DDBSRC            2
      *
      * Read forwards
     C                   PARM                    @RDFWD            1
      *
      * Read backwards
     C                   PARM                    @RDBCK            1
      *
      * Outputs :
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Base rate currency and code read
     C                   PARM      *BLANK        @CYCDRed          3
     C                   PARM      *BLANK        @BSRCRed          2

     C                   ENDSR
      **********************************************************************
     C     SDBSRTRTV     BEGSR
      **********************************************************************

     C                   CALLB     'SDBSRTRTV'

      * Inputs
      * Return code
     C                   PARM      *BLANKS       ReturnCode

      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1

      * Action code
     C                   PARM                    DDACTN            1
      *
      * Front Office transaction ID
     C                   PARM                    APFOTRANID       20
      *
      * Midas base rate currency
     C                   PARM                    DDCYCD            3
      *
      * Midas base rate number
     C                   PARM                    DDBSRC            2

      * Outputs
      * Current base rate in file format
     C                   PARM                    BasRFilFmt

      * OK - Action code
     C                   PARM                    OKActn            1
      *
      * OK - Currency code
     C                   PARM                    OKCYCD            1
      *
      * OK - Base rate code
     C                   PARM                    OKBSRC            1

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * ICD - Private banking
     C                   PARM                    BGN4ST            1
      *
      * Midas base rate shortname
     C                   PARM                    DDBSRS            5
      *
      * Midas base rate name
     C                   PARM                    DDBSRN           30

      * Base rate authorisation required
     C                   PARM                    AUTHRQ            1

      * Authorisation mode
     C                   PARM                    AUTHMD            1

     C                   ENDSR
      **********************************************************************
     C     SDBSRTCVT     BEGSR
      **********************************************************************

     C                   CALLB     'SDBSRTCVT'

      * Inputs
      * Return code
     C                   PARM                    ReturnCode

      * Current base rate in file format
     C                   PARM                    BasRFilfmt

      * Outputs
      * Current base rate in screen format
     C                   PARM                    BasRScnfmt
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103

      * The file structure is a bit weird - there is a 'current' rate plus
      * value date, and a 'new' one.  The 'new' rate will apply after the
      * next CoB, but it is shown on the browse/listview screen as the
      * 'current' rate.  On the detailed screen, both are shown separately.
      * Annoyingly, the CVT module overwrites the rate but not the value
      * date.
     C*******************IF        BAVDNR  <> 0                                              BUG4660
     C*******************Z-ADD     BAVDNR        WUWMDT                                      BUG4660
      *******************                                                                    BUG4660
     C*******************CALLB     'ZDATE2'                                                  BUG4660
     C*******************PARM                    WUWMDT            5 0                       BUG4660
     C*******************PARM                    BJDFIN                                      BUG4660
     C*******************PARM      *ZERO         WUWCDT            6 0                       BUG4660
     C*******************PARM      *BLANK        WUWADT            7                         BUG4660
      *******************                                                                    BUG4660
     C*******************MOVEL     WUWADT        DDVDRC                                      BUG4660
     C*******************ENDIF                                                               BUG4660
     C                   ENDSR
      **********************************************************************
      /EJECT
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

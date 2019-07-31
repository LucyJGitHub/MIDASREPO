     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management retrieve a record')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data module                                 *
      *                                                               *
      *  SDDCMTR - SD Document Management retrieve a record           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
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
 
     D DCMTScnFmt    E DS                  EXTNAME(SDDCMSPD)
      * Document Management screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D DCMTFilFmt    E DS                  EXTNAME(SDDCMTPD)
      ** Document Management File Format
 
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
 
     D PINMOD          S              1A
     D PINREF          S             10A
     D PINTYP          S              1A
     D PINCDE          S              2A
     D WSEQN           S              3A
     D PINSEQ          S              3S 0
     D DDACTNOK        S              1A
     D DDCODEOK        S              1A
     D DDDREFOK        S              1A
     D WERRMS          S              7A
 
      ** +--- Start of main processing -----------------------------------+
 
     C                   CLEAR                   DCMTFilFmt
 
     C                   MOVEL     *BLANK        WERRMS
      *
     C     DDREFN_In     IFNE      *BLANK
     C     DDRTYP_In     ANDNE     *BLANK
     C     DDCODE_In     ANDNE     *BLANK
     C     DDSEQN_In     ANDNE     *BLANK
      *
      * Retrieve base rate details
     C                   MOVEL     'E'           DDACTN
     C                   MOVEL     DDREFN_In     PINREF
     C                   MOVEL     DDRTYP_In     PINTYP
     C                   MOVEL     DDCODE_In     PINCDE
     C                   EVALR     WSEQN = %TRIM(DDSEQN_In)
     C                   MOVE      WSEQN         PINSEQ
     C                   MOVEL     'S'           APRespMode
     C                   EXSR      SDDCMTRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDDCMTCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C     WERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUST'      FldNameArr(1)
     C                   MOVEL     WERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Populate System Status for display
 
     C                   EVAL      DDSYST = *BLANKS
     C                   IF        BJRDNB > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                             AND DMSTCD <> 'C'
     C                   EVAL      DDSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
     C                   EVAL      DDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      DMTMST        @TimeStamp       26
     C                   EVAL      Buffer = DCMTScnfmt
     C                                      + @TimeStamp
 
     C                   SETON                                        LR
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    DDREFN_In        10
     C                   PARM                    DDRTYP_In         1
     C                   PARM                    DDCODE_In         2
     C                   PARM                    DDSEQN_In         3
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   EXSR      *PSSR
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
     C                   MOVE      'SDDCMTR'     DBPGM
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
     C     SDDCMTRTV     BEGSR
      **********************************************************************
 
     C                   CALLB     'SDDCMTRTV'
 
      * Inputs
      * Return code
     C                   PARM      *BLANKS       ReturnCode
 
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
 
      ** Entry Mode
     C                   PARM                    PINMOD
      * Action code
     C                   PARM                    DDACTN            1
      ** Customer and Document Code
     C                   PARM                    PINREF
     C                   PARM                    PINTYP
     C                   PARM                    PINCDE
     C                   PARM                    PINSEQ
      *
      * Front Office transaction ID
     C                   PARM                    APFOTRANID       20
 
      * Outputs
      * Current base rate in file format
     C                   PARM                    DCMTFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Currency code
     C                   PARM                    DDDrefOK
 
      * OK - Base rate code
     C                   PARM                    DDCodeOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Base rate shortname
     C                   PARM                    DDNARR
 
     C                   ENDSR
      **********************************************************************
     C     SDDCMTCVT     BEGSR
      **********************************************************************
 
     C                   CALLB     'SDDCMTCVT'
 
      * Inputs
      * Return code
     C                   PARM                    ReturnCode
 
      * Current base rate in file format
     C                   PARM                    DCMTFilfmt
 
      * Outputs
      * Current base rate in screen format
     C                   PARM                    DCMTScnfmt
 
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
(c) Finastra International Limited 2014

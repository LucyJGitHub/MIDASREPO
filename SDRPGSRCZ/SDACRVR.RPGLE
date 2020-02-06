     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data module                                 *
      *                                                               *
      *  SDACRVR - Midas SD Account review retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026205           Date 07Apr14               *
      *                 CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026205 - Serious midas error in account review             *
      *  CSD092 - Account Review                                      *
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
 
     D ACRVScnFmt    E DS                  EXTNAME(SDACRFPD)
      ** Account review in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D ACRVFilFmt    E DS                  EXTNAME(SDACRVPD)
      ** Account Review in file format
 
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
     D WERRMS          S              7A
 
      ** +--- Start of main processing -----------------------------------+
 
     C                   CLEAR                   ACRVFilFmt
 
     C                   MOVEL     *BLANK        WERRMS
      *
      * If account review read and no error message returned
     C     DDARCU_In     IFNE      *BLANK
     C     DDARSD_In     ANDNE     *BLANK
     C     DDARSQ_In     ANDNE     *BLANK
      *
      * Retrieve account review details
     C                   MOVEL     'E'           DDACTN
     C                   MOVEL     DDARCU_In     DDCUST
     C                   MOVEL     DDARSD_In     DDSCDF
     C                   MOVEL     DDARSQ_In     DDSEQN
     C                   MOVEL     'S'           APRespMode
     C                   EXSR      SDACRVRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDACRVCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C     WERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUST'      FldNameArr(1)
     C                   MOVEL     WERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      ARTMST        @TimeStamp       26
     C                   EVAL      Buffer = ACRVScnfmt
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
     C**********         PARM                    FwdBck            1                        MD026205
     C                   PARM                    DDARCU_In         6
     C                   PARM                    DDARSD_In         6
     C                   PARM                    DDARSQ_In         3
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
 
     C                   ENDSR
      **********************************************************************
     C     SDACRVRTV     BEGSR
      **********************************************************************
 
     C                   CALLB     'SDACRVRTV'
 
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
      * Midas base rate currency
     C                   PARM                    DDCUST
      *
      * Midas base rate number
     C                   PARM                    DDSCDF
      *
      * Midas base rate number
     C                   PARM                    DDSEQN
      *
      * Front Office transaction ID
     C                   PARM                    APFOTRANID       20
     C                   PARM                    WDCOMP            1                        MD026205
 
      * Outputs
      * Current base rate in file format
     C                   PARM                    ACRVFilFmt
 
      * OK - Action code
     C                   PARM                    OKActn            1
      *
      * OK - Customer number
     C                   PARM                    OKCust            1
     C                   PARM                    SDSCDTok          1                        MD026205
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      **********************************************************************
     C     SDACRVCVT     BEGSR
      **********************************************************************
 
     C                   CALLB     'SDACRVCVT'
 
      * Inputs
      * Return code
     C                   PARM                    ReturnCode
 
      * Current base rate in file format
     C                   PARM                    ACRVFilfmt
 
      * Outputs
      * Current base rate in screen format
     C                   PARM                    ACRVScnfmt
 
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

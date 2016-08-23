     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Collateral type details database update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCOTYUPD - Collateral type Details                          *
      *              database update                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
     FSDCOTPL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Collateral type Details Master File
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Standing Data Controls index
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D ChkCotyFmt    E DS                  EXTNAME(SDCOTPPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVCoty       E DS                  EXTNAME(SDVCOTYPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid collateral Detail
 
     D OKCotDets     E DS                  EXTNAME(SDECOTYPD)
      * Error indicators
 
     D B_COTYF       E DS                  EXTNAME(SDCOTPPD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' collateral type
 
      **  Collateral Details File
     D COTYF         E DS                  EXTNAME(SDCOTPPD)
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      * I :  File name
     D    PBFNME               1     10
      * I :  Long Key
     D    PBLKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      * I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      * I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      * I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      * I :  Last Change Date
     D    PBLCD             3061   3063P 0
      * I :  Type of Last Change
     D    PBTYLC            3064   3064
 
     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000
 
 
     D @Timestamp      S             26Z
 
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
     C     A_COTYLC      CASEQ     'I'           INSERT
     C     A_COTYLC      CASEQ     'A'           AMEND
     C     A_COTYLC      CASEQ     'D'           DELETE
     C                   ENDCS
 
      * Exit From Program
     C     EXIT          TAG
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    @@RTCD            7
 
      ** Externally described DS for valid Collateral Detail
     C                   PARM                    SDVCOTY
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  =  909                                * DBERR 909 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Customer details
 
     C                   CALLB     'SDCOTYRTV'
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      ' '           @@RSMD            1
      *
      * Action Code
     C                   PARM      A_COTYLC      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_COFRNT      FOTRID           20
      *
      * Midas Collateral type code
     C                   PARM                    A_COCOLT          5
      *
      * Outputs
      *
      * Collateral Details in File Format
     C                   PARM                    ChkCotyFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - Collateral code
     C                   PARM                    DDCOLTOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
     C                   IF        @TYPE = '1'
 
     C                   IF        CHCTTMST <> A_COTMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDCOLTOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError         132
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a transaction                                *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
 
      ** Access Collateral Details
     C     A_COCOLT      CHAIN     SDCOTPL0                           99
      ** Database error
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY  = A_COCOLT
     C                   EVAL      DBFILE = 'SDCOTPPD'
     C                   EVAL      DBASE  =  900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Collateral Detail
     C                   CLEAR                   COTYF
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  COTYF         B_COTYF
 
      ** SET COLLATERAL FIELDS ON INSERT
     C                   MOVEL     A_CORECI      CTRECI
     C                   MOVEL     A_COCOLT      CTCOLT
     C                   MOVEL     BJRDNB        CTLCD
     C                   MOVEL     A_COTYLC      CTTYLC
     C                   CALLB     'ZTNLU1'
     C                   PARM                    Returncode       10
     C                   PARM                    NATN              5 0
     C                   MOVEL     NATN          CTTNLU
     C                   MOVEL     A_COCOLD      CTCOLD
     C                   MOVEL     A_COCOPT      CTCOPT
     C                   MOVEL     A_COMPCT      CTMPCT
     C                   MOVEL     A_CORTNP      CTRTNP
     C                   MOVEL     A_CORVLM      CTRVLM
     C                   MOVEL     A_CORVLD      CTRVLD
     C                   MOVEL     A_CORVLF      CTRVLF
     C                   MOVEL     A_CORVLN      CTRVLN
     C                   MOVEL     A_COFRNT      CTFRNT
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      CTTMST  = TimeStamp
      *
      ** Write new collateral Detail
     C                   WRITE     SDCotpD0
 
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a transaction                                 *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access Collateral Details
     C     A_COCOLT      CHAIN     SDCOTPL0                           9998
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_COCOLT
     C                   EVAL      DBFILE = 'SDCOTPPD'
     C                   EVAL      DBASE  =  901
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Record locked
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_COCOLT
     C                   EVAL      DBFILE = 'SDCOTPPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  COTYF         B_COTYF
 
     ** SET COLLATERAL FIELDS ON AMEND
     C                   MOVEL     A_CORECI      CTRECI
     C                   MOVEL     A_COCOLT      CTCOLT
     C                   MOVEL     BJRDNB        CTLCD
     C                   MOVEL     A_COTYLC      CTTYLC
     C                   CALLB     'ZTNLU1'
     C                   PARM                    Returncode       10
     C                   PARM                    NATN              5 0
     C                   MOVEL     NATN          CTTNLU
     C                   MOVEL     A_COCOLD      CTCOLD
     C                   MOVEL     A_COCOPT      CTCOPT
     C                   MOVEL     A_COMPCT      CTMPCT
     C                   MOVEL     A_CORTNP      CTRTNP
     C                   MOVEL     A_CORVLM      CTRVLM
     C                   MOVEL     A_CORVLD      CTRVLD
     C                   MOVEL     A_CORVLF      CTRVLF
     C                   MOVEL     A_CORVLN      CTRVLN
     C                   MOVEL     A_COFRNT      CTFRNT
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      CTTMST  = TimeStamp
 
 
      *
      ** Update Collateral Record
     C                   UPDATE    SDCOTPD0
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
 
      ** Access Collateral Details
     C     A_COCOLT      CHAIN     SDCOTPL0                           9998
     ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_COCOLT
     C                   EVAL      DBFILE = 'SDCOTPPD'
     C                   EVAL      DBASE  =  903
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Record locked
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_COCOLT
     C                   EVAL      DBFILE = 'SDCOTPPD'
     C                   EVAL      DBASE  =  904
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  COTYF         B_COTYF
 
      ** Delete record
     C                   DELETE    SDCOTPD0
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDCTRL - UPDATE STANDING DATA CONTROL FILE                  *
     C*                                                              *
     C****************************************************************
     C     UPDCTRL       BEGSR
      *
     C                   MOVE      *BLANKS       WKFLNM           10
     C                   MOVEL     'SDCOTPPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
      *
      * Record not found
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDCOTPPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     905           DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      * Record locked
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDCOTPPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     906           DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   SELECT
      * Input
     C     A_COTYLC      WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
      *
      * Amend
     C     A_COTYLC      WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
      *
      * Delete
     C     A_COTYLC      WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006

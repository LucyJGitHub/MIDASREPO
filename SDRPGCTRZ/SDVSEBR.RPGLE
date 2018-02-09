     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Settlement Branch')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Settlement Branch    *
      *                                                               *
      *  SDVSEBR - Validate Settlement Branch                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *    not be applied to this source.                             *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ =====================================¦
      ** +-------------------------------------- +
      ** External DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for customer details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Rundate
     DRUNDAT           DS
     DMRDT                     1      7
     DRDNB                     8     10P 0
     DSUC                     11     11
     DDFF                     12     12
     DMBIN                    13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Multi-branching Indicator
     D WUMBIN          S              1A
      ** Define work field Single Branch Code
     D WUSBRC          S              3A
      ** Branch return Code
     D WUBRCD          S              3A
      **
     D DBOPTN          S              7A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDSEBR          S              3A
     D DDSTTY          S              2A
     D DDSEBROK        S              1A
     D FOSEBR          S              3A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Validate Settlement Branch,
      ** Multi-branching Indicator is Multi-branched
     C                   IF        WUMBIN = 'Y'
      ** Settlement Type is Any Account
     C                   IF        DDSTTY = '05'
      ** Settlement Branch is equal to Blank,
     C                   IF        DDSEBR  = *BLANK
      ** Send message 'Settlement Branch Require'
     C                   EVAL      DDSEBROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSEBR    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1201'
     C                   ENDIF
      ** Else for Settlement type
     C                   ELSE
 
      ** Settlement Branch is  not equal to Blank,
     C                   IF         DDSEBR <> *BLANK
      ** Send message 'Settlement Branch Blank'
     C                   EVAL      DDSEBROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSEBR    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1200'
     C                   ENDIF
      ** EndIf for settlement branch,
     C                   ENDIF
     C                   ELSE
      ** Get default branch - Bank Details *
     C                   EVAL      DDSEBR = WUSBRC
      ** EndIf for Multi - Branch Indicator
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
      ** Settlement Branch
     C                   PARM                    DDSEBR
      ** Settlement Type
     C                   PARM                    DDSTTY
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Settlement Branch - OK
     C                   PARM                    DDSEBROK
      ** Return settlement Branch
     C                   PARM                    FOSEBR
      ** Get Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MBIN          WUMBIN
 
      ** Access the Midas SD bank details file for single branch code(SBRC)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     900           DBASE
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   ENDIF
      ** Single Branch Code is moved to the work variable.
     C                   EVAL      WUSBRC = BJSBRC
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006

     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Validation - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDCUS10VL - SD Customers Validation - LU Window              *
      *                                                               *
      *  Function: This Function validates SD Extended Customers      *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CER001  *CREATE    Date 25Apr005              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Midas Upgrade to MidasPlus                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                              error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
      ** DS for access programs, short Data
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** New Customer in File Format
      *
     D NwDlFilFmt    E DS                  EXTNAME(SDVCULX1PD)
      *
      ** New Customer in Screen Format
      *
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
      *
      ** Error fields indicators
      *
     D OkFlags       E DS                  EXTNAME(SDECULX1PD)
      *
      ** Data passed from caller program
      *
     D/COPY QWINDSRC,SDCUSDDTA
     D PDATA           DS          1024
     D**#1FLD1**               1      6  0                                                   CSD027A
 
     D  #1CUST                 1      6
     D  #1PAIN                 7      7
     D  #1PCNB                 8     13
     D  #1COLC                15     16
     D  #1LINC                17     18
     D  #1BRCD                19     21
     D  #1BNBI                22     22
     D  #2CNCZ                23     24
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
     D  #1CRNM                91    110
     D  #1NCOS               111    114
 
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
      *
      ** Define parameters for call module
      *
     D BRBKCO          S              2S 0
      *
      ** Error message fields received as parameters
      *
     D Msg1            S                   LIKE(#MsgID)
     D Msg2            S                   LIKE(#MsgID)
     D Msg3            S                   LIKE(#MsgID)
     D Msg4            S                   LIKE(#MsgID)
     D Msg5            S                   LIKE(#MsgID)
     D Msg6            S                   LIKE(#MsgID)
     D Msg7            S                   LIKE(#MsgID)
      *
      ** Warning error message fields received as parameters
      *
     D WMSGID1         S                   LIKE(#MsgID)
     D WMSGID2         S                   LIKE(#MsgID)
     D WMSGID3         S                   LIKE(#MsgID)
     D WMSGID4         S                   LIKE(#MsgID)
     D WMSGID5         S                   LIKE(#MsgID)
     D WMSGID6         S                   LIKE(#MsgID)
     D WMSGID7         S                   LIKE(#MsgID)
      *
      ** Error message substitution data received as a parameter
      *
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
     D WLLXTYP2        S              1
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
     C                   EXSR      SRTYPE
      *
      ** Identification and Immatriculation should be validated only if
      ** Customer Type is OK
      *
     C     OK#LLXTYPE    IFNE      'N'
      *
      ** If the Customer Type is a resident, validate fields
      *
     C                   MOVE      LLLXTYPE      WLLXTYP2
     C     WLLXTYP2      IFEQ      'R'
     C     LLLXTYPE      OREQ      'ML'
     C     BRBKCO        ANDEQ     21
     C                   EXSR      SRIDCO
     C                   EXSR      SRIMCO
      *
     C                   ELSE
      *
     C                   EVAL      LLLXIDCO = *BLANKS
     C                   EVAL      LLLXIDEN = *BLANKS
     C                   EVAL      LLLXIMCO = *BLANKS
     C                   EVAL      LLLXIMNB = *BLANKS
     C                   ENDIF
     C                   ENDIF
      *
     C     Idx           IFEQ      0
     C     WIdx          ANDEQ     0
     C                   EXSR      SRSETUP
     C                   ENDIF
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRTYPE - Routine to validate CUTYPE                           *
      *****************************************************************
      *
     C     SRTYPE        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVCUTYPE2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLLXTYPE
     C                   PARM                    #1COLC
     C                   PARM                    #1CUST
     C                   PARM                    #1BNBI
     C                   PARM                    #1BRCD
     C                   PARM                    BRBKCO
     C                   PARM                    #1NCOS
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXTYPE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXTYPE
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRIDCO - Routine to validate CUIDCO and CUIDEN                *
      *****************************************************************
      *
     C     SRIDCO        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVCUIDCO2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    LLLXIDCO
     C                   PARM                    LLLXIDEN
     C                   PARM                    LLLXTYPE
     C                   PARM                    #1CUST
     C                   PARM                    #1BRCD
     C                   PARM                    #1BNBI
     C                   PARM                    BRBKCO
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXIDCO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C     MSG2          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXIDEN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDEN
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C     MSG3          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXTYPE'
     C                   EVAL      MsgIDArr(Idx) = MSG3
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXTYPE
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRIMCO - Routine to validate CUIMCO and CUIMNB                *
      *****************************************************************
      *
     C     SRIMCO        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVCUIMCO2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    WMSGID1
     C                   PARM                    LLLXIDCO
     C                   PARM                    LLLXIDEN
     C                   PARM                    LLLXIMCO
     C                   PARM                    LLLXIMNB
     C                   PARM                    LLLXTYPE
     C                   PARM                    #1CUST
     C                   PARM                    #1BRCD
     C                   PARM                    BRBKCO
      *
     C     WMSGID1       IFNE      *BLANKS
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNamArr(WIdx) = 'LLLXIMCO'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIMCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIMNB
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXIMCO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIMCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C     MSG2          IFNE      *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'LLLXIMNB'
     C                   EVAL      MsgIDArr(Idx) = MSG2
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIMNB
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up additional fields that are needed on the     *
      *           Valid file record.                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSETUP       BEGSR
      *
      ** Other VLxxxx fields are set up during validation, such as the
      ** ones where the input & database formats are different, e.g.
      ** dates, amounts.
      ** This SR sets up the fields with the same (or compatible)
      ** attributes.
      *
     C                   MOVE      #1CUST        #LLXCUCNUM
      *
     C                   MOVE      LLLXTYPE      #LLXCUTYPE
     C                   MOVE      LLLXIDCO      #LLXCUIDCO
     C                   MOVE      LLLXIDEN      #LLXCUIDEN
     C                   MOVE      LLLXIMCO      #LLXCUIMCO
     C                   MOVE      LLLXIMNB      #LLXCUIMNB
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PDATA
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUS10VL'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
      *
      * The following /COPY sets these values, and also defines LDA as
      * an external data area
     C/COPY ZACPYSRC,DBERREXIT
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005

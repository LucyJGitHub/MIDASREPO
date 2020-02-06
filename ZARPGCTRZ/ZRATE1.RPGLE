     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Edt rate dsp w/o sign/right just')
      *****************************************************************
      *                                                               *
     C* ZRATE1 - Module to convert a rate to display, no sign         *
     C*          and no right justify                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 21Jan98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** +-- The converted ZRATE1Z1 starts here --------------------------+
      *
      * WORK ARRAY USED FOR ZRATE1 TO HOLD RATE
     D WArr            S              1    DIM(13)
      ** +-- The converted ZRATE1Z1 ends here ----------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      * Rate to be edited                                             *
     DInputR           S             11P 7
      * Edited output rate                                            *
     DOutputR          S             13A
      * Field to hold decimal digits for input rate                   *
     DHDecs            S              7A
      * Field to hold integers for input rate                         *
     DHInts            S              4A
      * Counter field                                                 *
     DCount            S              2P 0
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
      *
      ** +-- The converted ZRATE1Z2 starts here --------------------------+
      *
     C**  If the rate is negative reverse the sign.
     C*
     C     InputR        IFLT      0                                            B1
     C                   Z-SUB     InputR        InputR           11 7          *1
     C                   END                                                    E1
     C*
     C**  Separate integers and decimal digits into two fields.
     C*
     C                   MOVE      InputR        HDecs
     C                   MOVEL     InputR        HInts
     C*
     C**  Move integers, decimal separator and decimal digits into
     C**  work array.
     C*
     C                   MOVEA     HInts         WArr
     C                   MOVE      '.'           WArr(5)
     C                   MOVEA     HDecs         WArr(6)
     C*
     C**  Remove leading zeros from the rate and replace with blanks.
     C*
     C                   Z-ADD     1             Count
     C     Count         DOWLE     3                                            B1
     C     WArr(Count)   ANDEQ     '0'                                          X1
     C                   MOVE      *BLANK        WArr(Count)                    *1
     C                   ADD       1             Count                          *1
     C                   END                                                    E1
     C*
     C**  Truncate trailing zeros and replace with blanks. If rate is
     C**  an integer a single zero after the decimal place should be
     C**  displayed.
     C*
     C                   Z-ADD     12            Count
     C     Count         DOWGE     7                                            B1
     C     WArr(Count)   ANDEQ     '0'                                          X1
     C                   MOVE      *BLANK        WArr(Count)                    *1
     C                   SUB       1             Count                          *1
     C                   END                                                    E1
     C*
     C**  Move the final array into the output field.
     C*
     C                   MOVEA     WArr          OutputR
     C*
     C     ZRAT19        TAG                                                    **ZRAT19**
     C                   RETURN
      *
      ** +-- The converted ZRATE1Z2 ends here -----------------------------+
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    InputR
     C                   PARM                    OutputR
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001

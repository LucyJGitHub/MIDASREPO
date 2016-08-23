     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Mailing Name and Address (1-2)')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVPAAD01 - Validate Mailing Name and Address (Lines 1-2)    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG25853           Date 03Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25853 - Mailing address line 1-2 should be optional       *
      *  CGL031 - Taxation on Savings Income                          *
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
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D OkCNA1          S              1
     D OkCNA2          S              1
     D DDCNA1          S             35
     D DDCNA2          S             35
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** Initialisation
 
     C                   Move      *BLANK        RetCodeIn
 
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-Add     0             Idx
 
      ** Validation
 
     C                   Exsr      SRVCAD12
 
      ** If an error was found, set the return code appropriately
 
     C     OkCNA1        Ifeq      'N'
     C     OkCNA2        Oreq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Endif
      ** Return
     C                   Return
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVCAD12 - Validate Lines 1 and 2                            *
      *                                                               *
      *****************************************************************
     C     SRVCAD12      BEGSR
 
      ***Fields*are*mandatory                                                               BUG25853
 
     C**********         IF        DDCNA1 = *Blanks and                                     BUG25853
     C**********                   DDCNA2 = *Blanks                                         BUG25853
     C**********         Move      'N'           OkCNA1                                     BUG25853
     C**********         Move      'N'           OkCNA2                                     BUG25853
     C**********         Add       1             Idx                                        BUG25853
     C**********         MoveL     'DDCNA1'      FldNamXAr(Idx)                             BUG25853
als  C**********         MoveL     'USR4796'     MsgIdXAr(Idx)                              BUG25853
     C**********         Add       1             Idx                                        BUG25853
     C**********         MoveL     'DDCNA2'      FldNamXAr(Idx)                             BUG25853
als  C**********         MoveL     'USR4796'     MsgIdXAr(Idx)                              BUG25853
     C**********         ENDIF                                                              BUG25853
 
      ** If Line 1 is input, line 2 must be input and vice-versa
 
     C                   IF        DDCNA1 = *BLANKS AND
     C                             DDCNA2 <> *BLANKS
     C                   Move      'N'           OkCNA1
     C                   Add       1             Idx
     C                   MoveL     'DDCNA1'      FldNamXAr(Idx)
als  C                   MoveL     'USR0220'     MsgIdXAr(Idx)
     C                   Endif
 
     C                   IF        DDCNA1 <> *BLANKS AND
     C                             DDCNA2 =  *BLANKS
     C                   Move      'N'           OkCNA2
     C                   Add       1             Idx
     C                   MoveL     'DDCNA2'      FldNamXAr(Idx)
als  C                   MoveL     'USR0220'     MsgIdXAr(Idx)
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        Begsr
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
      ** Mailing Name and Address 1
      ** Mailing Name and Address 2
     C                   Parm                    RetCodeIn
     C                   Parm                    DDCNA1
     C                   Parm                    DDCNA2
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Mailing Name and Address 1-2 OK
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    OkCNA1
     C                   Parm                    OkCNA2
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004

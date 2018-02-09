     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Details Crosscheck')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTXCK01 - Crosscheck Tax Details                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      *  Prev Amend No. 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ***Country*of Tax Codes by County                                                       232543
     F*SDCTTXL2**IF   E           K DISK    INFSR(*PSSR)                                      232543
      ** Non-account Holders by Country of Tax                                                232543
     FSDNHTXL0  IF   E           K DISK    INFSR(*PSSR)                                       232543
 
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
 
     D @RUN            S              1
     D @@COLC          S              2
     D TaxStatus       S              1
     D OkDBTH          S              1
     D OkBTHC          S              1
     D OkBTHT          S              1
     D OkTINO          S              1
     D DDTINO          S             10
     D DDIDTP          S              2
     D DDISCT          S              2
     D DDISDT          S              6
     D DDDBTH          S              8
     D DDBTHC          S              2
     D DDBTHT          S             35
     D DDCOLC          S              2
     D DDNAHO          S             10                                                       232543
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Key Fields                                                                           232543
     D KNAHO           S                   LIKE(DDNAHO)                                       232543
     D KCOLC           S                   LIKE(DDCOLC)                                       232543
                                                                                              232543
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Crosscheck
 
     C                   Exsr      SRXCK01
 
      ** If an error was found, set the return code appropriately
 
     C     OkDBTH        Ifeq      'N'
     C     OkBTHC        Oreq      'N'
     C     OkBTHT        Oreq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Endif
      * Return
     C                   Return
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Crosscheck
      *****************************************************************
     C     SRXCK01       BEGSR
 
      ** Birth information or Tax ID cannot be both blank if
      ** Tax Status is 'D'isclosed
 
     C                   IF        TaxStatus = 'D'
 
     C                   IF        DDTINO = *Blanks  and
     C                             DDDBTH = *Blanks  and
     C                             DDBTHC = *Blanks  and
     C                             DDBTHT = *Blanks
     C                   EVAL      OKTINO = 'N'
     C                   EVAL      OKDBTH = 'N'
     C                   EVAL      OKBTHC = 'N'
     C                   EVAL      OKBTHT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTINO'      FldNamXAr(Idx)
     C                   MOVEL     'USR4781'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If Tax Identification number is blank,
      ** birth information (date, country and town)
      ** is mandatory.
     C     DDTINO        Ifeq      *BLANKS
 
     C                   If        DDDBTH = *BLANKS
     C                   Move      'N'           OkDBTH
     C                   Add       1             Idx
     C                   Movel     'DDDBTH'      FldNamXAr(Idx)
als  C**********         Movel     'USR0220'     MsgIdXAr(Idx)                                232543
     C                   Movel     'USR4797'     MsgIdXAr(Idx)                                232543
     C                   Endif
 
     C                   If        DDBTHC = *BLANKS
     C                   Move      'N'           OkBTHC
     C                   Add       1             Idx
     C                   Movel     'DDBTHC'      FldNamXAr(Idx)
als  C**********         Movel     'USR0220'     MsgIdXAr(Idx)                                232543
     C                   Movel     'USR4798'     MsgIdXAr(Idx)                                232543
     C                   Endif
 
     C                   If        DDBTHT = *BLANKS
     C                   Move      'N'           OkBTHT
     C                   Add       1             Idx
     C                   Movel     'DDBTHT'      FldNamXAr(Idx)
als  C**********         Movel     'USR0220'     MsgIdXAr(Idx)                                232543
     C                   Movel     'USR4799'     MsgIdXAr(Idx)                                232543
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit -                                                      *
      *****************************************************************
     C     SRInit        Begsr
 
     C                   EVAL      TaxStatus = *Blanks                                        232543
     C                   EVAL      NXETXS = *Blanks                                           232543
                                                                                              232543
      ** Access Tax Status from Customer's Country of Residence
 
     C**********         EVAL      @@COLC = DDCOLC                                            232543
     C**********         EVAL      EWTXS1 = *BLANKS                                           232543
 
     C*****@@COLC        CHAIN     SDCTTXL2                                                   232543
 
     C**********         IF        NOT %FOUND(SDCTTXL2)                                       232543
 
      ***If*no*record is found, use a blank key...                                            232543
 
     C**********         EVAL      @@COLC = *BLANKS                                           232543
     C*****@@COLC        CHAIN     SDCTTXL2                                                   232543
     C**********         ENDIF                                                                232543
 
     C**********         EVAL      TaxStatus = EWTXS1                                         232543
 
     C     DDNAHO        SETLL     SDNHTXL0                                                   232543
     C     DDNAHO        READE     SDNHTXL0                                                   232543
                                                                                              232543
     C                   DOW       Not %EOF(SDNHTXL0)                                         232543
     C                             And NXETXS <> 'D'                                          232543
     C     DDNAHO        READE     SDNHTXL0                                                   232543
     C                   ENDDO                                                                232543
                                                                                              232543
     C                   IF        NXETXS = 'D'                                               232543
     C                   EVAL      TaxStatus = NXETXS                                         232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Initialization
 
     C                   Move      *BLANK        RetCodeIn
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-Add     0             Idx
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        Begsr
 
     C     *Entry        Plist
 
      ** Inputs
      ** Return Code
      ** Tax Identification Number
      ** Identification Type
      ** Issuing Country
      ** Issuing Date
      ** Date of Birth
      ** Place of Birth - Country
      ** Place of Birth - Town
      ***Error*Field*Name                                                                     232543
      ** Non-a/c Holder Reference                                                             232543
      ** Country of Tax                                                                       232543
     C                   Parm                    RetCodeIn
     C                   Parm                    DDTINO
     C                   Parm                    DDIDTP
     C                   Parm                    DDISCT
     C                   Parm                    DDISDT
     C                   Parm                    DDDBTH
     C                   Parm                    DDBTHC
     C                   Parm                    DDBTHT
     C                   Parm                    DDNAHO                                       232543
     C                   Parm                    DDCOLC
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ***Mailing*Name*and Address 1-2 OK                                                      232543
      ** Error flags for Tin Number and Birth Info                                            232543
      ** Tax Status                                                                           232543
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    OkDBTH
     C                   Parm                    OkBTHC
     C                   Parm                    OkBTHT
     C                   PARM                    OKTINO                                       232543
     C                   Parm                    TaxStatus
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004

     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Take-on program for SDCSSWPD')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000800 - Midas SD Take-on program for SDCSSWPD             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. MD022764           Date 11Oct13               *
      *                 CFT050             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14969A*CREATE   Date 11Oct07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD022764 - CSW207 Initialisation must be taken into account  *
      *             for CFT050.                                       *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  BUG14969A - Customer details error after update (Reopen)     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSTL1  IF   E           K Disk
     FSDCSSWL1  IF A E           K Disk
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Midas Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   Read      SDCUSTL1
     C                   DoW       Not %EOF(SDCUSTL1)
 
     C     BBCUST        Chain     SDCSSWL1
     C                   If        Not %Found(SDCSSWL1)
 
     C                   Clear                   SDCSSWD0                                   MD022764
                                                                                            MD022764
     C                   Eval      CSCUSD = BBCUST
     C                   Eval      CSBRCA = BBBRCD
 
     C                   If        BGN4ST = 'N'
     C                   Eval      CSCICI = *Blanks
     C                   Else
 
     C                   If        BBBNBI = 'N'
     C                   Eval      CSCICI = 'RETL'
     C                   Else
     C                   Eval      CSCICI = 'PROF'
     C                   EndIf
     C                   EndIf
 
     C                   Eval      CSCPCI = *Blanks
     C                   Eval      CSIBEI = *Blanks
 
     C                   Write     SDCSSWD0
 
     C                   EndIf
 
     C                   Read      SDCUSTL1
 
     C                   EndDo
 
     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas Module details.
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2007

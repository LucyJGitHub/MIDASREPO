     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(SMXLIBQT) TOFILE(QADSPOBJ)                       *
/*S*D****RPGBASEBND****************************************************                       CUP042
/*STD *  RPGSQLBND                                                    *                       CUP042
/*EXI *  TEXT('Midas SM Check contents of XLIB')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0025 - Check contents of XLIB                              *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CUP042             Date 07Nov14               *
      *  Prev Amend No. CUP041             Date 04Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP016 *CREATE     Date 01Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Changes for Bridge deliverable data split           *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** File containing list of objects in "from" XLIB.
     FSMXLIBQT  IF   E             DISK
     F***SMSETULG* IFE           K DISK                                                       CUP042
     F***UPAPGMPDIF  E             DISK                                                       CUP041
     FUPADPUW0  IF   E             DISK                                                       CUP041
     FUPNOTFPD  O    E             DISK    RENAME(QLIDOBJD:NOTF)
      *
      * Array for Adoption programs
     D  AdoptProg      S             10    DIM(999) ASCEND
      *
     D Subsystem       S             10
     D Recursive       S              1
     D AdoptIdx        S              3  0
      *
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
      * Parameters
     C     *ENTRY        PLIST
     C                   PARM                    SystemID          2
      *
      * Build array of adoption programs
     C                   EXSR      AdoptionArray
      *
     C                   EVAL      Subsystem = 'M' +
     C                             SystemID +
     C                             'SBS'
      *
      * Key list for SMSETULG.
     C     ObjAndType    KLIST
     C                   KFLD                    KObject          10
     C                   KFLD                    KType            10
      *
      * Read first record.
     C     1             SETLL     SMXLIBQT
     C                   READ      SMXLIBQT                               15
     C     *IN15         IFEQ      *ON
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   DOU       *IN15 = *ON
      *
      * Check if object exists in core.
     C                   EVAL      KObject = ODOBNM
     C                   EVAL      KType = ODOBTP
     C*****ObjAndType    CHAIN     SMSETULG                           16                      CUP042
     C/exec SQL                                                                               CUP042
     C+ select                                                                                CUP042
     C+   DFNAME                                                                              CUP042
     C+ into                                                                                  CUP042
     C+   :KObject                                                                            CUP042
     C+ from SMIMPJW0                                                                         CUP042
     C+ where                                                                                 CUP042
     C+     DFNAME = :KObject                                                                 CUP042
     C+ and DFTYPE = :KType                                                                   CUP042
     C/end-exec                                                                               CUP042
      *
      * If object not found ...
     C**********         IF        *IN16 = *ON and                                            CUP042
     C                   IF        SQLCODE <> 0 and                                           CUP042
     C                             ODOBNM <> Subsystem
      * ... and not an adoption program.
     C     ODOBNM        LOOKUP    AdoptProg(1)                           30
     C                   IF        *IN30 = *OFF
     C                   WRITE     NOTF
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SMXLIBQT                               15
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  AdoptionArray - Build Array of adoption programs             *
      *                                                               *
      *****************************************************************
      *
     C     AdoptionArray BEGSR
      *
     C                   EVAL      AdoptIdx = 1
     C*****1****         SETLL     UPAPGMPD                                                   CUP041
     C**********         READ      UPAPGMPD                               20                  CUP041
     C     1             SETLL     UPADPUW0                                                   CUP041
     C                   READ      UPADPUW0                               20                  CUP041
      *
     C                   DOW       *IN20 = *OFF
     C                   EVAL      AdoptProg(AdoptIdx) = AAPGM
      *
     C                   EVAL      AdoptIdx = AdoptIdx + 1
     C**********         READ      UPAPGMPD                               20                  CUP041
     C                   READ      UPADPUW0                               20                  CUP041
      *
     C                   ENDDO
      *
     C     AdoptionArrayEENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *

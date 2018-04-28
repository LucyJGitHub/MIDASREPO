     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('TI Product Code/CSSF Product Type Trigger Module')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  ERLU13M - TI Product Code/CSSF Product Type Trigger Module   *
      *                                                               *
      *  Function:  This module is a trigger for ERTIPTPP             *
      *                                                               *
      *  Called By: Automatic (Trigger associated to the file)        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Last Amend No. ULX024  *CREATE    Date 03Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX024 - Trade Innovation/CSSF Reporting Interface           *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Midas TI Product Code/CSSF Product Type
     FERTIPTL0  UF A E           K DISK    INFSR(*PSSR) USROPN
      *
      /EJECT
      *
      ***  Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      /SPACE 3
      *
      ***  Data Area giving Installation Control Details
     D PSDS           SDS
      *
      ***  Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ***  Bank details.
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***  DS for Access Programs, Long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ***  DS for Access Programs, Long data structure.
     D DSSFN         E DS                  EXTNAME(DSSDY)
     D                                     PREFIX(DS)
      *
      /EJECT
      *
      ***  TRIGGER  ***
      *
     D PARM1           DS
      * Physical file name
     D  FNAME                        10
      * Physical file library
     D  LNAME                        10
      * Member name
     D  MNAME                        10
      * Trigger event 1=Ins, 2=Del, 3=Upd
     D  TEVEN                         1
      * Trigger time  1=After, 2=Before
     D  TTIME                         1
      * Commit lock level
     D  CMTLCK                        1
      * Reserved
     D  FILL1                         3
      * CCSID
     D  CCSID                         9B 0
      * Reserved
     D  FILL2                         8
      * Offset to the original record (Add 1!)
     D  OLDOFF                        9B 0
      * length of the original record
     D  OLDLEN                        9B 0
      * Offset to the original record null byte map (Add 1!)
     D  ONOFF                         9B 0
      * length of the null byte map
     D  ONLEN                         9B 0
      * Offset to the new record (Add 1!)
     D  NEWOFF                        9B 0
      * length of the new record
     D  NEWLEN                        9B 0
      * Offset to the new record null byte map (Add 1!)
     D  NNOFF                         9B 0
      * length of the null byte map
     D  NNLEN                         9B 0
      * Reserved
     D  RESV3                        16
      * Records
     D  RECS                        630
 
      * Trigger Buffer Length
     D PARM2           DS
     D  LENG                          9B 0
 
      * Record to be inserted or new values
     D NEW           E DS                  EXTNAME(ERTIPTPP)
 
      * Set up the entry parameter list.
     C     *ENTRY        PLIST
     C     PARM1         PARM                    PARM1
     C     PARM2         PARM                    PARM2
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *                 M A I N   R O U T I N E                       *
      *                                                               *
      *****************************************************************
      *
      *
      ***  Load Parameter info in File DS
      *
      *
     C                   EVAL      NEW = %SUBST(PARM1:NEWOFF+1:NEWLEN)
      *
      ***  Access table to update
      *
      *
 
     C     KERPT         CHAIN     ERTIPTL0                           50
      *
     C                   EVAL      ERTIPC=WKTIPC
     C                   EVAL      ERTIPT=WKTIPT
     C                   EVAL      ERTIPD=WKTIPD
     C                   EVAL      ERTCHT='U'
     C                   EVAL      ERTLCD=BJRDNB
      *
     c                   IF        *IN50=*off
     C                   UPDATE    ERTIPTD0
     C                   ELSE
     c                   WRITE     ERTIPTD0
     c                   END
      *
      ** Close file if needed
      *
     C                   CLOSE     ERTIPTL0                             99
     C                   RETURN
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   CLOSE     ERTIPTL0                             99
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *ZINSR - SR for initialization program.                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVEL     LNAME         SBSID             2
     C                   MOVEL     *BLANKS       ERROR            50
      *
      ***  Setup environment
      *
     C                   CALLB     'ERLU13CM'
     C                   PARM                    SBSID
      *
      ***  Open Database file
      *
     C                   OPEN      ERTIPTL0
      *
      ***  Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     DSBANK        PARM      DSBANK        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      ERROR = 'Rejection code 99 - Data Base +
     C                             Error in ERLU13, file +
     C                             SDBANKPD, at 001, Key *FIRST'
     C                   DUMP
     C                   CLOSE     ERTIPTL0                             99
     C                   RETURN
     C                   ENDIF
      *
      *** Declaration KLIST for ERTIPTL0
      *
     C     KERPT         KLIST
     C                   KFLD                    WKTIPC
     C                   KFLD                    WKTIPT
      *
     C                   ENDSR
      *
      /EJECT
**   CPY@
(c) Misys International Banking Systems Ltd. 2005
